
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List
from pydantic import BaseModel
from datetime import datetime
import traceback
import sys

from database import engine, SessionLocal, get_db, Base
from models import WaterData
from alert_engine import analyze_water_quality

# Create database tables
print("Creating database tables...")
Base.metadata.create_all(bind=engine)
print("✅ Tables created/verified")

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
    # Test database connection
    try:
        db = SessionLocal()
        db.execute(text("SELECT 1"))
        db.close()
        db_status = "connected"
    except Exception as e:
        db_status = f"error: {e}"
    
    return {
        "message": "Smart Water Quality Monitor API",
        "status": "running",
        "database": db_status
    }

@app.post("/api/water-quality/check", response_model=WaterQualityResponse)
def check_water_quality(request: WaterQualityRequest, db: Session = Depends(get_db)):
    try:
        print(f"\n{'='*50}")
        print(f"📥 Received Request at {datetime.now()}")
        print(f"📊 Data: ph={request.ph}, tds={request.tds}, turbidity={request.turbidity}, temp={request.temperature}, source={request.source}")
        
        # Analyze water quality
        result = analyze_water_quality(
            ph=request.ph,
            tds=request.tds,
            turbidity=request.turbidity,
            temperature=request.temperature
        )
        
        print(f"📊 Analysis: status={result['status']}, alerts={len(result['alerts'])}")
        
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
        
        print(f" Saved to database with ID: {db_record.id}")
        print('='*50)
        
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
        print(f"\n ERROR in check_water_quality:")
        print(f"Type: {type(e).__name__}")
        print(f"Message: {str(e)}")
        print("\nTraceback:")
        traceback.print_exc(file=sys.stdout)
        print('='*50)
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
        print(f" History request: found {len(records)} records")
        return records
    
    except Exception as e:
        print(f" History error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# @app.get("/api/water-quality/latest")
# def get_latest_reading(db: Session = Depends(get_db)):
#     try:
#         latest = db.query(WaterData).order_by(WaterData.timestamp.desc()).first()
#         if not latest:
#             return {"message": "No records found"}
#         return latest
#     except Exception as e:
#         print(f" Latest reading error: {e}")
#         raise HTTPException(status_code=500, detail=str(e))


# @app.get("/api/water-quality/latest")
# def get_latest_reading(db: Session = Depends(get_db)):
#     try:
#         # Check if table exists first
#         from sqlalchemy import inspect
#         inspector = inspect(db.bind)
#         if not inspector.has_table("water_data"):
#             print(" Table 'water_data' doesn't exist yet")
#             return {"message": "No records found", "status": "empty"}
        
#         # Try to get the latest record
#         latest = db.query(WaterData).order_by(WaterData.timestamp.desc()).first()
        
#         if not latest:
#             print(" No records found in database")
#             return {"message": "No records found", "status": "empty"}
        
#         print(f" Latest reading found: ID={latest.id}, pH={latest.ph_level}")
#         return latest
    
#     except Exception as e:
#         print(f" Latest reading error: {e}")
#         # Return empty state instead of 500 error
#         return {"message": "No records found", "status": "empty"}




@app.get("/api/water-quality/latest")
def get_latest_reading(db: Session = Depends(get_db)):
    try:
        # Check if table exists first
        from sqlalchemy import inspect
        inspector = inspect(db.bind)
        
        # Check if water_data table exists
        if not inspector.has_table("water_data"):
            print("⚠️ Table 'water_data' doesn't exist yet - creating tables...")
            # Try to create tables
            Base.metadata.create_all(bind=db.bind)
            # Check again
            if not inspector.has_table("water_data"):
                return {"message": "No records found", "status": "empty"}
        
        # Try to get the latest record
        latest = db.query(WaterData).order_by(WaterData.timestamp.desc()).first()
        
        if not latest:
            print("📭 No records found in database")
            return {"message": "No records found", "status": "empty"}
        
        print(f"✅ Latest reading found: ID={latest.id}, pH={latest.ph_level}")
        return latest
    
    except Exception as e:
        print(f"❌ Latest reading error: {e}")
        # Return empty state instead of 500 error
        return {"message": "No records found", "status": "empty"}