from files_app.schemas import File
from pydantic import BaseModel

from files_app.schemas import FileAnomaliesBase


class Event(BaseModel):
    event_name: str = ""
    is_major: bool = False

class FileProcessed(Event):
    status_code: int = 200
    status_message: str = "File processed successfully"
    file: File
    
class FileProcessError(Event):
    status_code: int = 400
    status_message: str = "File processing failed"
    file_anomaly: FileAnomaliesBase

class Notification(Event):
    user_id: str
    title: str
    description: str
