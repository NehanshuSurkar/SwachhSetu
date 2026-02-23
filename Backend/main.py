# from fastapi import FastAPI, Depends
# from sqlalchemy.orm import Session
# from database import SessionLocal, engine
# from models import WaterData
# from database import Base

# app = FastAPI()

# Base.metadata.create_all(bind=engine)

# SAFE_THRESHOLD = 50

# def get_db():
#     db = SessionLocal()
#     try:
#         yield db
#     finally:
#         db.close()

# @app.get("/history")
# def get_history(db: Session = Depends(get_db)):
#     data = db.query(WaterData).all()
#     return data        

# @app.post("/check-water")
# def check_water(value: float, db: Session = Depends(get_db)):

#     if value <= SAFE_THRESHOLD:
#         status = "SAFE"
#         alert = "NO ALERT"
#     else:
#         status = "UNSAFE"
#         alert = " ALERT SENT"
#         print("SMS: Water quality is unsafe!")

#     data = WaterData(value=value, status=status, alert=alert)
#     db.add(data)
#     db.commit()
#     db.refresh(data)

#     return {
#         "value": value,
#         "status": status,
#         "alert": alert
#     }



# from fastapi import FastAPI, Depends, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from sqlalchemy.orm import Session
# from typing import List
# from pydantic import BaseModel
# from datetime import datetime

# from database import engine, SessionLocal, get_db, Base
# from models import WaterData
# from alert_engine import analyze_water_quality

# # Create database tables
# Base.metadata.create_all(bind=engine)

# app = FastAPI(title="Smart Water Quality Monitor API")

# # CORS middleware
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# # Pydantic models
# class WaterQualityRequest(BaseModel):
#     ph: float
#     tds: float
#     turbidity: float
#     temperature: float
#     source: str

# class WaterQualityResponse(BaseModel):
#     status: str
#     alerts: List[str]
#     timestamp: datetime
#     ph: float
#     tds: float
#     turbidity: float
#     temperature: float

# class HistoryResponse(BaseModel):
#     id: int
#     timestamp: datetime
#     ph_level: float
#     tds_level: float
#     turbidity_level: float
#     temperature: float
#     source: str
#     status: str
#     alert: str

#     class Config:
#         from_attributes = True

# @app.get("/")
# def root():
#     return {"message": "Smart Water Quality Monitor API", "status": "running"}

# @app.post("/api/water-quality/check", response_model=WaterQualityResponse)
# def check_water_quality(request: WaterQualityRequest, db: Session = Depends(get_db)):
#     try:
#         # Analyze water quality
#         result = analyze_water_quality(
#             ph=request.ph,
#             tds=request.tds,
#             turbidity=request.turbidity,
#             temperature=request.temperature
#         )
        
#         # Create database record
#         db_record = WaterData(
#             ph_level=request.ph,
#             tds_level=request.tds,
#             turbidity_level=request.turbidity,
#             temperature=request.temperature,
#             source=request.source,
#             status=result["status"],
#             alert=str(result["alerts"])
#         )
        
#         db.add(db_record)
#         db.commit()
#         db.refresh(db_record)
        
#         # Print alert if unsafe
#         if result["status"] == "Unsafe":
#             print(f"\n ALERT: Unsafe water detected!")
#             for alert in result["alerts"]:
#                 print(f"   - {alert}")
        
#         return WaterQualityResponse(
#             status=result["status"],
#             alerts=result["alerts"],
#             timestamp=result["timestamp"],
#             ph=request.ph,
#             tds=request.tds,
#             turbidity=request.turbidity,
#             temperature=request.temperature
#         )
    
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))

# @app.get("/api/water-quality/history", response_model=List[HistoryResponse])
# def get_water_history(
#     source: str = None,
#     limit: int = 30,
#     db: Session = Depends(get_db)
# ):
#     try:
#         query = db.query(WaterData).order_by(WaterData.timestamp.desc())
        
#         if source:
#             query = query.filter(WaterData.source == source)
        
#         records = query.limit(limit).all()
#         return records
    
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))

# @app.get("/api/water-quality/latest")
# def get_latest_reading(db: Session = Depends(get_db)):
#     try:
#         latest = db.query(WaterData).order_by(WaterData.timestamp.desc()).first()
#         if not latest:
#             return {"message": "No records found"}
#         return latest
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))


from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from pydantic import BaseModel
from datetime import datetime
import traceback
import sys

from database import engine, SessionLocal, get_db, Base
from models import WaterData
from alert_engine import analyze_water_quality

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Smart Water Quality Monitor API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models
class WaterQualityRequest(BaseModel):
    ph: float
    tds: float
    turbidity: float
    temperature: float
    source: str

class WaterQualityResponse(BaseModel):
    status: str
    alerts: List[str]
    timestamp: datetime
    ph: float
    tds: float
    turbidity: float
    temperature: float

class HistoryResponse(BaseModel):
    id: int
    timestamp: datetime
    ph_level: float
    tds_level: float
    turbidity_level: float
    temperature: float
    source: str
    status: str
    alert: str

    class Config:
        from_attributes = True

@app.get("/")
def root():
    return {"message": "Smart Water Quality Monitor API", "status": "running"}

@app.post("/api/water-quality/check", response_model=WaterQualityResponse)
def check_water_quality(request: WaterQualityRequest, db: Session = Depends(get_db)):
    try:
        print(f"\n=== Received Request ===")
        print(f"ph: {request.ph}")
        print(f"tds: {request.tds}")
        print(f"turbidity: {request.turbidity}")
        print(f"temperature: {request.temperature}")
        print(f"source: {request.source}")
        
        # Analyze water quality
        result = analyze_water_quality(
            ph=request.ph,
            tds=request.tds,
            turbidity=request.turbidity,
            temperature=request.temperature
        )
        
        print(f"\n=== Analysis Result ===")
        print(f"status: {result['status']}")
        print(f"alerts: {result['alerts']}")
        
        # Create database record
        db_record = WaterData(
            ph_level=request.ph,
            tds_level=request.tds,
            turbidity_level=request.turbidity,
            temperature=request.temperature,
            source=request.source,
            status=result["status"],
            alert=str(result["alerts"])
        )
        
        db.add(db_record)
        db.commit()
        db.refresh(db_record)
        
        print(f"\n=== Saved to Database ===")
        print(f"Record ID: {db_record.id}")
        
        # Print alert if unsafe
        if result["status"] == "Unsafe":
            print(f"\n🚨 ALERT: Unsafe water detected!")
            for alert in result["alerts"]:
                print(f"   - {alert}")
        
        return WaterQualityResponse(
            status=result["status"],
            alerts=result["alerts"],
            timestamp=result["timestamp"],
            ph=request.ph,
            tds=request.tds,
            turbidity=request.turbidity,
            temperature=request.temperature
        )
    
    except Exception as e:
        print(f"\n❌ ERROR in check_water_quality:")
        print(f"Error type: {type(e).__name__}")
        print(f"Error message: {str(e)}")
        print("\nFull traceback:")
        traceback.print_exc(file=sys.stdout)
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/water-quality/history", response_model=List[HistoryResponse])
def get_water_history(
    source: str = None,
    limit: int = 30,
    db: Session = Depends(get_db)
):
    try:
        query = db.query(WaterData).order_by(WaterData.timestamp.desc())
        
        if source:
            query = query.filter(WaterData.source == source)
        
        records = query.limit(limit).all()
        print(f"\n=== History Request ===")
        print(f"Found {len(records)} records")
        return records
    
    except Exception as e:
        print(f"\n❌ ERROR in get_water_history:")
        print(f"Error message: {str(e)}")
        traceback.print_exc(file=sys.stdout)
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/water-quality/latest")
def get_latest_reading(db: Session = Depends(get_db)):
    try:
        latest = db.query(WaterData).order_by(WaterData.timestamp.desc()).first()
        if not latest:
            print("\n=== Latest Request: No records found ===")
            return {"message": "No records found"}
        
        print(f"\n=== Latest Request ===")
        print(f"Found record ID: {latest.id}")
        return latest
    
    except Exception as e:
        print(f"\n❌ ERROR in get_latest_reading:")
        print(f"Error message: {str(e)}")
        traceback.print_exc(file=sys.stdout)
        raise HTTPException(status_code=500, detail=str(e))