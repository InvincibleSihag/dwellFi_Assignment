from typing import List
from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from files_app import schemas
import services

files_router = APIRouter(prefix="/files", tags=['Files'])

@files_router.post("/uploadfile/", response_model=schemas.File)
async def upload_file(file: UploadFile = File(...), db: Session = Depends(get_db)):
    if file.content_type != "application/json":
        raise HTTPException(status_code=400, detail="Invalid file type")
    contents = await file.read()
    file_size = len(contents)
    if file_size > 10 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="File too large")
    file_data = schemas.FileCreate(filename=file.filename, size=file_size, type=file.content_type)
    return services.file_service.create_file(db=db, file=file_data)

@files_router.get("/files/", response_model=List[schemas.File])
async def get_files(db: Session = Depends(get_db)):
    return services.file_service.get_files(db=db)

@files_router.get("/files/{file_id}", response_model=schemas.File)
async def get_file(file_id: int, db: Session = Depends(get_db)):
    return services.file_service.get_file(db=db, file_id=file_id)