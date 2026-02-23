from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from models import WaterData
from database import Base

app = FastAPI()

Base.metadata.create_all(bind=engine)

SAFE_THRESHOLD = 50

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/check-water")
def check_water(value: float, db: Session = Depends(get_db)):

    if value <= SAFE_THRESHOLD:
        status = "SAFE"
        alert = "NO ALERT"
    else:
        status = "UNSAFE"
        alert = "🚨 ALERT SENT"
        print("SMS: Water quality is unsafe!")

    data = WaterData(value=value, status=status, alert=alert)
    db.add(data)
    db.commit()
    db.refresh(data)

    return {
        "value": value,
        "status": status,
        "alert": alert
    }