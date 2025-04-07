from typing import List, Optional

from sqlalchemy.orm import Session

from app.db.base import SessionLocal
from app.models.sector import Sector
from app.repositories.base import BaseRepository
from app.schemas.sector import SectorCreate, SectorResponse, SectorSearch, SectorUpdate


class SectorRepository(BaseRepository[Sector, SectorCreate, SectorUpdate]):
    def get_by_name(self, db: Session, *, name: str) -> Optional[Sector]:
        return db.query(Sector).filter(Sector.name == name).first()

    def search_sectors(self, db: Session, *, search: SectorSearch) -> List[Sector]:
        return self.get_by_filter(db, search.name, search.description, search.is_active)


sector_repository = SectorRepository(Sector)
