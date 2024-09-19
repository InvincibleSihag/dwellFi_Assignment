import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "DwellFi Assignment"
    admin_email: str = "sawansingsihag@gmail.com"
    items_per_user: int = 50
    database_url: str = os.environ.get("DATABASE_CONN", "sqlite:///./sql_app.db")
    access_token_expire_minutes: int = 30
    REDIS_HOST: str = "localhost"
    REDIS_PORT: int = 6379
    REDIS_NOTIFY_DB: int = 0
    REDIS_USERNAME: str = "default"
    REDIS_PASSWORD: str = "password"

    class Config:
        env_file = ".env"

settings = Settings()
