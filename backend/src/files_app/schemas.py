import datetime
from pydantic import BaseModel
from typing import Optional

class FileBase(BaseModel):
    filename: str
    size: Optional[int] = None
    type: str
    is_processed: Optional[bool] = False
    meta_data: Optional[dict] = None
    task_id: Optional[str] = None
    task_status: Optional[str] = None

class FileCreate(FileBase):
    id: int

class FileUpdate(FileBase):
    pass

class File(FileBase):
    id: int
    created_at: datetime.datetime
    updated_at: datetime.datetime
    created_by_id: Optional[str] = None
    updated_by_id: Optional[str] = None

class FileAnomaliesBase(BaseModel):
    file_id: int
    data: str

class FileAnomaliesCreate(FileAnomaliesBase):
    pass

class FileAnomalies(FileAnomaliesBase):
    id: int
