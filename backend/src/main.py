from fastapi import FastAPI
from files_app.routes import files_router
from starlette.middleware.cors import CORSMiddleware

app = FastAPI()
origins = ["http://localhost:3000"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(files_router)