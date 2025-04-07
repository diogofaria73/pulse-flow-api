from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class SectorBase(BaseModel):
    name: str
    description: Optional[str] = None
    is_active: bool


class SectorCreate(SectorBase):
    id: Optional[int] = None
    created_at: Optional[datetime] = None


class SectorUpdate(SectorBase):
    id: Optional[int] = None
    updated_at: Optional[datetime] = None


class SectorResponse(SectorBase):
    id: int
    created_at: datetime
    updated_at: datetime


class SectorSearch(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None
