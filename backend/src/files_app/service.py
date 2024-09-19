from sqlalchemy.orm import Session
from .. import models, schemas

def create_file(db: Session, file: schemas.FileCreate):
    db_file = models.File(**file.dict())
    db.add(db_file)
    db.commit()
    db.refresh(db_file)
    return db_file

def get_files(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.File).offset(skip).limit(limit).all()
