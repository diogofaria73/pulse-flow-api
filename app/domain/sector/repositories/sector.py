from typing import List, Optional

from sqlalchemy.orm import Session

from app.domain.common.repositories.base import BaseRepository
from app.domain.sector.models.sector import Sector
from app.domain.sector.schemas.sector import SectorCreate, SectorUpdate


class SectorRepository(BaseRepository[Sector, SectorCreate, SectorUpdate]):
    def get_by_name(self, db: Session, name: str) -> Optional[Sector]:
        return db.query(Sector).filter(Sector.name == name).first()

    def search_sectors(self, db: Session, id: Optional[int] = None, name: Optional[str] = None, is_active: Optional[bool] = None) -> List[Sector]:
        return self.get_by_filter(db, id=id, name=name, is_active=is_active)


sector_repository = SectorRepository(Sector) 