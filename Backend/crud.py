# crud.py

from sqlalchemy.orm import Session
import models
import schemas

def create_household(db: Session, household: schemas.HouseholdCreate):
    db_household = models.Household(**household.dict())
    db.add(db_household)
    db.commit()
    db.refresh(db_household)
    return db_household


def create_reading(db: Session, reading):
    db_reading = models.WaterReading(**reading)
    db.add(db_reading)
    db.commit()
    db.refresh(db_reading)
    return db_reading


def create_alert(db: Session, household_id: int, message: str):
    alert = models.Alert(household_id=household_id, message=message)
    db.add(alert)
    db.commit()
    return alert