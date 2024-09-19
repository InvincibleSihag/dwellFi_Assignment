from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from config import settings
import dotenv

dotenv.load_dotenv()

engine = create_engine(
    settings.database_url,
    pool_pre_ping=True,
    # connect_args={"sslmode": "require"},
    pool_size=50, max_overflow=0, pool_recycle=900
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


