# from sqlalchemy import Column, DateTime, Integer, Float, String
# from database import Base

# class WaterData(Base):
#     __tablename__ = "water_data"

#     id = Column(Integer, primary_key=True, index=True)
#     value = Column(Float)
#     status = Column(String)
#     alert = Column(String)


from sqlalchemy import Column, Integer, Float, String, DateTime
from database import Base
from datetime import datetime

class WaterData(Base):
    __tablename__ = "water_data"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime, default=datetime.now)
    ph_level = Column(Float)
    tds_level = Column(Float)
    turbidity_level = Column(Float)
    temperature = Column(Float)
    source = Column(String)
    status = Column(String)
    alert = Column(String)