import redis
from celery_app import celery_app
from notification.schemas import FileProcessed, FileProcessError
from files_app.models import File
from database import SessionLocal
from config import settings

redis_client =  redis.Redis(host=settings.redis_host,
                           port=settings.redis_port,
                           db=settings.REDIS_NOTIFY_DB,
                           username=settings.REDIS_USERNAME,
                           password=settings.REDIS_PASSWORD)

@celery_app.task
def process_json_file(file_id: int, user_id: str):
    db = SessionLocal()
    try:
        file = db.query(File).filter(File.id == file_id).first()
        if not file:
            raise Exception(f"File with id {file_id} not found.")
        
        # Simulate file processing
        file.is_processed = True
        db.commit()

        # Create a FileProcessed event
        event = FileProcessed(
            event_name="file_processed",
            is_major=True,
            file=file
        )
        # Publish the event to the Redis channel
        redis_client.publish(user_id, event)
    except Exception as e:
        # Create a FileProcessError event
        event = FileProcessError(
            event_name="file_process_error",
            is_major=True,
            file_anomaly={"file_id": file_id, "error": str(e)}
        )
        # Publish the event to the Redis channel
        redis_client.publish(user_id, event)
    finally:
        db.close()
