# Import all models that should be included in the migrations
from app.infrastructure.db.session import Base
from app.domain.user.models.user import User
from app.domain.sector.models.sector import Sector 