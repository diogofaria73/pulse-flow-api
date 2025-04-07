from typing import List, Optional

from sqlalchemy.orm import Session

from app.models.sector import Sector
from app.repositories.sector import sector_repository
from app.schemas.sector import SectorCreate, SectorSearch, SectorUpdate


class SectorService:
    def create_sector(self, db: Session, sector_in: SectorCreate) -> Sector:
        # Check if sector with same name already exists
        db_sector = sector_repository.get_by_name(db, name=sector_in.name)
        if db_sector:
            raise ValueError(f"Sector with name '{sector_in.name}' already exists")
        
        # Create new sector
        return sector_repository.create(db, obj_in=sector_in)
    
    def get_sector(self, db: Session, sector_id: int) -> Optional[Sector]:
        return sector_repository.get(db, id=sector_id)
    
    def get_all_sectors(self, db: Session) -> List[Sector]:
        return sector_repository.get_all(db)
    
    def update_sector(self, db: Session, sector_id: int, sector_in: SectorUpdate) -> Optional[Sector]:
        sector = sector_repository.get(db, id=sector_id)
        if not sector:
            return None
        
        # Check name uniqueness if updating name
        if sector_in.name and sector_in.name != sector.name:
            existing_sector = sector_repository.get_by_name(db, name=sector_in.name)
            if existing_sector:
                raise ValueError(f"Sector with name '{sector_in.name}' already exists")
        
        return sector_repository.update(db, db_obj=sector, obj_in=sector_in)
    
    def search_sectors(self, db: Session, search_params: SectorSearch) -> List[Sector]:
        return sector_repository.search_sectors(
            db, 
            id=search_params.id,
            name=search_params.name
        )
    
    def activate_deactivate_sector(self, db: Session, sector_id: int, is_active: bool) -> Optional[Sector]:
        sector = sector_repository.get(db, id=sector_id)
        if sector:
            update_data = {"is_active": is_active}
            return sector_repository.update(db, db_obj=sector, obj_in=update_data)
        return None


sector_service = SectorService()
