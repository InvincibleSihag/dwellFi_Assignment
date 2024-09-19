from pydantic import BaseModel


class Event(BaseModel):
    event_name: str = ""
    is_major: bool = False

class FileProcessed(Event):
    status_code: int = 200
    status_message: str = "File processed successfully"
    
class FileProcessError(Event):
    status_code: int = 400
    status_message: str = "File processing failed"
