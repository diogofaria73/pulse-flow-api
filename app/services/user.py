from typing import List, Optional
import hashlib

from sqlalchemy.orm import Session

from app.models.user import User
from app.repositories.user import user_repository
from app.schemas.user import UserCreate, UserSearch, UserUpdate


def hash_password(password: str) -> str:
    """Simple password hashing using SHA-256. In production, use more secure methods."""
    return hashlib.sha256(password.encode()).hexdigest()


class UserService:
    def create_user(self, db: Session, user_in: UserCreate) -> User:
        # Check if user already exists
        db_user = user_repository.get_by_email(db, email=user_in.email)
        if db_user:
            raise ValueError(f"Email {user_in.email} already registered")
        
        # Hash the password
        hashed_password = hash_password(user_in.password)
        user_data = user_in.model_dump()
        user_data["password"] = hashed_password
        
        # Create new user
        return user_repository.create(db, obj_in=UserCreate(**user_data))
    
    def get_user(self, db: Session, user_id: int) -> Optional[User]:
        return user_repository.get(db, id=user_id)
    
    def get_all_users(self, db: Session) -> List[User]:
        return user_repository.get_all(db)
    
    def get_active_users(self, db: Session) -> List[User]:
        return user_repository.get_active_users(db)
    
    def get_inactive_users(self, db: Session) -> List[User]:
        return user_repository.get_inactive_users(db)
    
    def update_user(self, db: Session, user_id: int, user_in: UserUpdate) -> Optional[User]:
        user = user_repository.get(db, id=user_id)
        if not user:
            return None
        
        # Hash password if provided
        update_data = user_in.model_dump(exclude_unset=True)
        if "password" in update_data and update_data["password"]:
            update_data["password"] = hash_password(update_data["password"])
        
        return user_repository.update(db, db_obj=user, obj_in=update_data)
    
    def search_users(self, db: Session, search_params: UserSearch) -> List[User]:
        return user_repository.search_users(
            db, 
            id=search_params.id,
            name=search_params.name,
            email=search_params.email
        )
    
    def activate_deactivate_user(self, db: Session, user_id: int, is_active: bool) -> Optional[User]:
        return user_repository.activate_deactivate(db, user_id=user_id, is_active=is_active)


user_service = UserService()
