from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class SectorBase(BaseModel):
    name: str
    description: Optional[str] = None
    is_active: bool = True


class SectorCreate(SectorBase):
    pass


class SectorUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None


class SectorResponse(SectorBase):
    id: int
    created_at: datetime
    updated_at: datetime

    model_config = {
        "from_attributes": True
    }


class SectorSearch(BaseModel):
    id: Optional[int] = None
    name: Optional[str] = None 