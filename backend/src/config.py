import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "DwellFi Assignment"
    admin_email: str = "sawansingsihag@gmail.com"
    database_url: str = "postgresql+psycopg2://localhost:5433/postgres"
    REDIS_HOST: str = "localhost"
    REDIS_PORT: int = 6379
    REDIS_NOTIFY_DB: int = 0
    # REDIS_USERNAME: str = "default"
    # REDIS_PASSWORD: str = "password"


settings = Settings()
