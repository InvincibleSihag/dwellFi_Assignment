from files_app.schemas import File
from pydantic import BaseModel

from files_app.schemas import FileAnomaliesBase


class Event(BaseModel):
    event_name: str = ""
    is_major: bool = False

class FileProcessed(Event):
    event_name: str = "File processed"
    file_id: int
    status_message: str = "File processed successfully"
    file: File
    
class FileProcessError(Event):
    event_name: str = "Anomalies detected"
    file_id: int
    status_message: str = "File processing failed"
    file_anomaly: FileAnomaliesBase

class Notification(Event):
    event_name: str = "Notification"
    user_id: str
    title: str
    description: str
