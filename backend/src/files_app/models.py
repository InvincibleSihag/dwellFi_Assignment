from sqlalchemy import JSON, Column, Integer, String, DateTime, Boolean, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base
from models import BaseMixin, BaseMixinWithCreatedBy

class File(BaseMixinWithCreatedBy, Base):
    __tablename__ = "files"
    id = Column(Integer, primary_key=True, index=True)
    filename = Column(String, index=True)
    size = Column(Integer)
    type = Column(String)
    is_processed = Column(Boolean, default=False)
    meta_data = Column(JSON, nullable=True)


class FileAnomalies(BaseMixinWithCreatedBy, Base):
    __tablename__ = "file_anomalies"
    id = Column(Integer, primary_key=True, index=True)
    file_id = Column(Integer, ForeignKey('files.id'))
    data = Column(String)
    file = relationship("File", back_populates="anomalies")

File.anomalies = relationship("FileAnomalies", order_by=FileAnomalies.id, back_populates="file")
