from sqlalchemy import Column, Integer, Float, String
from database import Base

class WaterData(Base):
    __tablename__ = "water_data"

    id = Column(Integer, primary_key=True, index=True)
    value = Column(Float)
    status = Column(String)
    alert = Column(String)