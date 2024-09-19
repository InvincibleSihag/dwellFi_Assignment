import datetime
from typing import Optional
from pydantic import BaseModel


class UserBase(BaseModel):
    username: str
    email: str
    password: str

class UserCreate(UserBase):
    pass

class User(UserBase):
    id: str
    
    class Config:
        orm_mode = True
