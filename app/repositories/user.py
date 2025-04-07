from typing import List, Optional

from sqlalchemy.orm import Session

from app.models.user import User
from app.repositories.base import BaseRepository
from app.schemas.user import UserCreate, UserUpdate


class UserRepository(BaseRepository[User, UserCreate, UserUpdate]):
    def get_by_email(self, db: Session, email: str) -> Optional[User]:
        return db.query(User).filter(User.email == email).first()

    def search_users(
        self,
        db: Session,
        id: Optional[int] = None,
        name: Optional[str] = None,
        email: Optional[str] = None,
        is_active: Optional[bool] = None,
    ) -> List[User]:
        return self.get_by_filter(
            db, id=id, name=name, email=email, is_active=is_active
        )

    def activate_deactivate(
        self, db: Session, *, user_id: int, is_active: bool
    ) -> Optional[User]:
        user = self.get(db, id=user_id)
        if user:
            user.is_active = is_active
            db.add(user)
            db.commit()
            db.refresh(user)
        return user


user_repository = UserRepository(User)
