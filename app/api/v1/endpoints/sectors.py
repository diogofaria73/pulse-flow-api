from typing import List, Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.dependencies import get_current_active_user
from app.db.session import get_db
from app.models.user import User
from app.schemas.sector import SectorCreate, SectorResponse, SectorSearch, SectorUpdate
from app.services.sector import sector_service

router = APIRouter()


@router.post("/", response_model=SectorResponse, status_code=status.HTTP_201_CREATED)
def create_sector(
    sector_in: SectorCreate,
    db: Session = Depends(get_db),
    current_user: Annotated[User, Depends(get_current_active_user)] = None,
):
    """Create a new hospital sector."""
    try:
        sector = sector_service.create_sector(db, sector_in)
        return sector
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


@router.get("/all", response_model=List[SectorResponse])
def get_all_sectors(
    db: Session = Depends(get_db),
):
    """Get all hospital sectors. This endpoint is not protected."""
    sectors = sector_service.get_all_sectors(db)
    if not sectors:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No sectors found",
        )
    return sectors


@router.get("/{sector_id}", response_model=SectorResponse)
def get_sector(
    sector_id: int,
    db: Session = Depends(get_db),
):
    """Get a hospital sector by ID. This endpoint is not protected."""
    sector = sector_service.get_sector(db, sector_id)
    if sector is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Sector with ID {sector_id} not found",
        )
    return sector


@router.put("/{sector_id}", response_model=SectorResponse)
def update_sector(
    sector_id: int,
    sector_in: SectorUpdate,
    db: Session = Depends(get_db),
    current_user: Annotated[User, Depends(get_current_active_user)] = None,
):
    """Update a hospital sector."""
    try:
        sector = sector_service.update_sector(db, sector_id, sector_in)
        if sector is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Sector with ID {sector_id} not found",
            )
        return sector
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


@router.post("/search", response_model=List[SectorResponse])
def search_sectors(
    search_params: SectorSearch,
    db: Session = Depends(get_db),
):
    """Search for hospital sectors by ID or name. This endpoint is not protected."""
    sectors = sector_service.search_sectors(db, search_params)
    return sectors


@router.patch("/{sector_id}/activate", response_model=SectorResponse)
def activate_sector(
    sector_id: int,
    db: Session = Depends(get_db),
    current_user: Annotated[User, Depends(get_current_active_user)] = None,
):
    """Activate a hospital sector."""
    sector = sector_service.activate_deactivate_sector(db, sector_id, True)
    if sector is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Sector with ID {sector_id} not found",
        )
    return sector


@router.patch("/{sector_id}/deactivate", response_model=SectorResponse)
def deactivate_sector(
    sector_id: int,
    db: Session = Depends(get_db),
    current_user: Annotated[User, Depends(get_current_active_user)] = None,
):
    """Deactivate a hospital sector."""
    sector = sector_service.activate_deactivate_sector(db, sector_id, False)
    if sector is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Sector with ID {sector_id} not found",
        )
    return sector
