import json
from typing import List
from fastapi import APIRouter, Depends, Form, Request, UploadFile, File, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from files_app import schemas
from tasks.celery_app import process_json_file
from .service import get_files, create_file, get_file, update_file

files_router = APIRouter(prefix="/files", tags=['Files'])


@files_router.post("/uploadfile/", response_model=schemas.File)
async def upload_file(request: Request, file_data_create_form:str =  Form(), file: UploadFile = File(...), db: Session = Depends(get_db)):
    if file.content_type != "application/json":
        raise HTTPException(status_code=400, detail="Invalid file type")
    contents = await file.read()
    file_create = schemas.FileCreate.model_validate(json.loads(file_data_create_form))
    file_size = len(contents)
    file_create.size = file_size
    if file_size > 10 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="File too large")
    file_schema: schemas.File  = create_file(db=db, file_create=file_create, user_id=request.state.user_id)
    # file_data = schemas.FileCreate(filename=file.filename, size=file_size, type=file.content_type)
    process_json_file.delay(file_schema.id, request.state.user_id, contents)
    return file_schema

@files_router.get("/files/", response_model=List[schemas.File])
def get_files_route(request: Request, db: Session = Depends(get_db)):
    return get_files(db, request.state.user_id)

@files_router.get("/files/{file_id}", response_model=schemas.File)
def get_file_route(request: Request, file_id: int, db: Session = Depends(get_db)):
    return get_file(db=db, file_id=file_id, user_id=request.state.user_id)

@files_router.put("/updatefile/{file_id}", response_model=schemas.File)
async def update_file_route(request: Request, file_id: int, file_update_form: str = Form(), file: UploadFile = File(None), db: Session = Depends(get_db)):
    file_update = schemas.FileUpdate.model_validate(json.loads(file_update_form))
    if file is not None and file.content_type != "application/json":
        raise HTTPException(status_code=400, detail="Invalid file type")
    file_obj = get_file(db=db, file_id=file_id, user_id=request.state.user_id)
    file_size = 0
    if file_obj:
        file_update.size = file_obj.size
    if file is not None:
        contents = await file.read()
        file_size = len(contents)
        file_update.size = file_size
        if file_size > 10 * 1024 * 1024:
            raise HTTPException(status_code=400, detail="File too large")
    updated_file_schema: schemas.File = update_file(db=db, file_update=file_update, file_id=file_id, user_id=request.state.user_id)
    if file is not None:
        process_json_file.delay(file_id, request.state.user_id, contents)
    return updated_file_schema
