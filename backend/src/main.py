from fastapi import FastAPI
from files_app.routes import files_router
from middlewares.user_auth_middleware import UserAuthentication
from notification.routes import events_routes
from starlette.middleware.cors import CORSMiddleware

app = FastAPI()
origins = ["http://localhost:3000", "http://localhost:61215"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(UserAuthentication)
app.include_router(files_router)
app.include_router(events_routes)
