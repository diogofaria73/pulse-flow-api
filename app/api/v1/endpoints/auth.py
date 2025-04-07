from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.security import create_access_token
from app.db.session import get_db
from app.schemas.auth import LoginRequest, Token
from app.schemas.user import UserCreate, UserResponse
from app.services.user import user_service

router = APIRouter()


@router.post("/login", response_model=Token)
def login_access_token(
    db: Annotated[Session, Depends(get_db)],
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
) -> Token:
    """
    OAuth2 compatible token login, get an access token for future requests.
    """
    user = user_service.authenticate_user(
        db, email=form_data.username, password=form_data.password
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    return Token(
        access_token=create_access_token(
            data={"sub": user.id}, expires_delta=access_token_expires
        ),
        token_type="bearer",
    )


@router.post("/login/json", response_model=Token)
def login_access_token_json(
    login_request: LoginRequest,
    db: Annotated[Session, Depends(get_db)],
) -> Token:
    """
    JSON login, get an access token for future requests.
    """
    user = user_service.authenticate_user(
        db, email=login_request.email, password=login_request.password
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    return Token(
        access_token=create_access_token(
            data={"sub": user.id}, expires_delta=access_token_expires
        ),
        token_type="bearer",
    )


@router.post(
    "/test-user", response_model=UserResponse, status_code=status.HTTP_201_CREATED
)
def create_test_user(
    db: Annotated[Session, Depends(get_db)],
) -> UserResponse:
    """
    Create a test user for development and testing purposes.
    This endpoint should not be available in production.
    """
    try:
        user_data = UserCreate(
            name="Test User",
            email="test@example.com",
            password="password123",
            is_active=True,
        )
        user = user_service.create_user(db, user_data)
        return user
    except ValueError as e:
        # Se o usuário já existir, tente obtê-lo
        user = user_service.get_user_by_email(db, email="test@example.com")
        if user:
            return user
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )
