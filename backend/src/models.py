from sqlalchemy.sql import func
from sqlalchemy import Column, DateTime, String, ForeignKey, Boolean, Integer
from sqlalchemy.orm import declarative_mixin, declared_attr

from database import Base


@declarative_mixin
class BaseMixin:
    __abstract__ = True

    id = Column(
        Integer, primary_key=True, index=True, nullable=False, unique=True,
        autoincrement=True
    )
    is_active = Column(Boolean, server_default='t')
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


class BaseMixinWithCreatedBy(BaseMixin):
    @declared_attr
    def created_by_id(self):
        # return Column(String(50), nullable=False)
        return Column(String(50), ForeignKey("user.id", ondelete='CASCADE'), nullable=True)

    @declared_attr
    def updated_by_id(self):
        # return Column(String(50), nullable=True)
        return Column(String(50), ForeignKey("user.id", ondelete='CASCADE'), nullable=True)



class User(BaseMixin, Base):
    __tablename__ = "user"
    id = Column(String(50), primary_key=True)
    username = Column(String(50), nullable=False, unique=True)
    email = Column(String(50), nullable=False, unique=True)
    password = Column(String(255), nullable=False)

