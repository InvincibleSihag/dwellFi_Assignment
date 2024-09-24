from datetime import time
from celery import Celery
from config import settings
import json
import redis
from files_app.schemas import File
from models import File as FileModel
from notification.schemas import FileProcessed, FileProcessError, FileAnomaliesBase
from database import SessionLocal
from config import settings

redis_client =  redis.Redis(host=settings.REDIS_HOST,
                           port=settings.REDIS_PORT,
                           db=settings.REDIS_NOTIFY_DB,
                        #    username=settings.REDIS_USERNAME,
                        #    password=settings.REDIS_PASSWORD
                           )

celery_app = Celery(
    broker=f"redis://{settings.REDIS_HOST}:{settings.REDIS_PORT}/0",
    backend=f"redis://{settings.REDIS_HOST}:{settings.REDIS_PORT}/0"
)

celery_app.conf.update(
    task_serializer='json',
    accept_content=['json'],
    result_serializer='json',
    timezone='UTC',
    enable_utc=True,
)

@celery_app.task
def process_json_file(file_id: int, user_id: str, json_file: bytes):
    db = SessionLocal()
    try:
        file = db.query(FileModel).filter(FileModel.id == file_id).first()
        if not file:
            raise Exception(f"File with id {file_id} not found.")
        file.task_status = "processing"
        db.commit()
        db.refresh(file)
        try:
            json_data = json.loads(json_file)
            time.sleep(10)
            file.meta_data = json_data
            file.is_processed = True
            file.task_status = "processed"
            db.commit()
            db.refresh(file)
        except json.JSONDecodeError as e:
            raise Exception(f"Error parsing JSON file: {e}")
        
        print(file.filename)
        event = FileProcessed(
            file_id=file_id,
            event_name="file_processed",
            is_major=True,
            status_message="File processed successfully",
            file=File(**file.__dict__)
        )
        redis_client.publish(user_id, event.model_dump_json())
        process_json_file_values.delay(file_id, user_id, json_data)
    except Exception as e:
        print(e)
        file.status = str(e)
        db.commit()
        db.refresh(file)
        event = FileProcessError(
            file_id=file_id,
            event_name="file_process_error",
            is_major=True,
            file_anomaly=FileAnomaliesBase(file_id=file_id, data=str(e))
        )
        redis_client.publish(user_id, event.model_dump_json())
    finally:
        db.close()

 
@celery_app.task
def process_json_file_values(file_id: int, user_id: str, json_file: dict):
    # Define acceptable ranges for metrics
    acceptable_ranges = {
        "cpu_usage": (0, 85),
        "memory_usage": (0, 90),
        "disk_read": (0, 1000),
        "disk_write": (0, 1000),
        "network_in": (0, 1000),
        "network_out": (0, 1000),
        "response_time": (0, 200)
    }

    anomalies = []

    # Iterate through the metrics in the JSON file
    for metric in json_file.get("metrics", []):
        for key, (min_val, max_val) in acceptable_ranges.items():
            if not (min_val <= metric.get(key, 0) <= max_val):
                anomalies.append(f"{key} out of range: {metric.get(key)} at {metric.get('timestamp')}")

    if anomalies:
        # Create a FileProcessError event
        event = FileProcessError(
            file_id=file_id,
            event_name="Anomalies detected",
            is_major=True,
            file_anomaly=FileAnomaliesBase(file_id=file_id, data=", ".join(anomalies))
        )
        redis_client.publish(user_id, event.model_dump_json())

