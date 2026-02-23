# schemas.py

from pydantic import BaseModel
from typing import List
from datetime import datetime

class HouseholdCreate(BaseModel):
    name: str
    phone: str
    location: str


class ReadingCreate(BaseModel):
    household_id: int
    ph: float
    tds: float
    turbidity: float


class ReadingResponse(BaseModel):
    status: str
    alerts: List[str]
    timestamp: datetime