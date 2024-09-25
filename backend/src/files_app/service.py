from typing import List
from fastapi import HTTPException
from sqlalchemy.orm import Session

from files_app.schemas import File, FileCreate, FileUpdate
from models import File as FileModel

def create_file(db: Session, file_create: FileCreate, user_id: str) -> File:
    db_file = FileModel(
        filename=file_create.filename,
        size=file_create.size,
        type=file_create.type,
        is_processed=False,
        meta_data=None,
        task_status="processing"
    )
    db_file.created_by_id = user_id
    db_file.updated_by_id = user_id
    db.add(db_file)
    db.commit()
    db.refresh(db_file)
    return File(**db_file.__dict__)

def update_file(db: Session, file_update: FileUpdate, file_id: int, user_id: str) -> File:
    db_file = db.query(FileModel).filter(FileModel.created_by_id == user_id, FileModel.id == file_id).first()
    if db_file is None:
        raise HTTPException(status_code=404, detail="File not found")
    db_file.filename = file_update.filename
    db_file.size = file_update.size
    db_file.type = file_update.type
    db_file.is_processed = False
    db_file.task_status = "processing"
    db.commit()
    db.refresh(db_file)
    return File(**db_file.__dict__)

def get_files(db: Session, user_id: str) -> List[File]:
    db_files: List[FileModel] = db.query(FileModel).filter(FileModel.created_by_id == user_id).all()
    files_schemas = [File(**db_file.__dict__) for db_file in db_files]
    # print(files_schemas)
    return files_schemas

def get_file(db: Session, user_id: str, file_id: int) -> File:
    db_file = db.query(FileModel).filter(FileModel.created_by_id == user_id, FileModel.id == file_id).first()
    if db_file is None:
        raise HTTPException(status_code=404, detail="File not found")
    return File(**db_file.__dict__)
