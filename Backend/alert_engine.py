# # alert_engine.py

# from datetime import datetime

# # BIS (Bureau of Indian Standards) Safe Drinking Limits
# PH_MIN = 6.5
# PH_MAX = 8.5
# TDS_MAX = 500        # ppm
# TURBIDITY_MAX = 5    # NTU


# def analyze_water_quality(ph: float, tds: float, turbidity: float):
#     """
#     Analyze water quality based on threshold values.
#     Returns:
#         {
#             "status": "Safe" / "Unsafe",
#             "alerts": [list of alert messages],
#             "timestamp": current time
#         }
#     """

#     alerts = []

#     # pH Check
#     if ph < PH_MIN:
#         alerts.append("Water is too acidic (Low pH).")
#     elif ph > PH_MAX:
#         alerts.append("Water is too alkaline (High pH).")

#     # TDS Check
#     if tds > TDS_MAX:
#         alerts.append("High TDS level detected (Excess dissolved solids).")

#     # Turbidity Check
#     if turbidity > TURBIDITY_MAX:
#         alerts.append("High turbidity detected (Water appears cloudy).")

#     # Final Status
#     if len(alerts) == 0:
#         status = "Safe"
#     else:
#         status = "Unsafe"

#     return {
#         "status": status,
#         "alerts": alerts,
#         "timestamp": datetime.now()
#     }

# ------------------------------------------------------------------------------------


# from datetime import datetime
# from sqlalchemy import create_engine, Column, Integer, Float, String, DateTime
# from sqlalchemy.orm import sessionmaker, declarative_base
# from fastapi import FastAPI, Depends, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# from typing import List
# import uvicorn

# # BIS (Bureau of Indian Standards) Safe Drinking Limits
# PH_MIN = 6.5
# PH_MAX = 8.5
# TDS_MAX = 500        # ppm
# TURBIDITY_MAX = 5    # NTU

# # Database Setup
# DATABASE_URL = "postgresql://postgres:Vedant1@localhost:5432/water_monitor"

# engine = create_engine(DATABASE_URL)
# SessionLocal = sessionmaker(bind=engine)
# Base = declarative_base()

# # Database Model
# class WaterQualityRecord(Base):
#     __tablename__ = "water_quality_records"

#     id = Column(Integer, primary_key=True, index=True)
#     timestamp = Column(DateTime, default=datetime.now)
#     ph_level = Column(Float)
#     tds_level = Column(Float)
#     turbidity_level = Column(Float)
#     temperature = Column(Float)
#     source = Column(String)  # 'tank' or 'tap'
#     status = Column(String)  # 'Safe', 'Moderate', 'Unsafe'
#     alerts = Column(String)  # JSON string of alerts

# Base.metadata.create_all(bind=engine)

# # Pydantic Models
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
#     alerts: str

#     class Config:
#         from_attributes = True

# # FastAPI App
# app = FastAPI(title="Smart Water Quality Monitor API")

# # CORS Middleware
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],  # In production, replace with your Flutter app's domain
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# # Dependency
# def get_db():
#     db = SessionLocal()
#     try:
#         yield db
#     finally:
#         db.close()

# def analyze_water_quality(ph: float, tds: float, turbidity: float, temperature: float):
#     """
#     Analyze water quality based on threshold values.
#     """
#     alerts = []

#     # pH Check
#     if ph < PH_MIN:
#         alerts.append("Water is too acidic (Low pH - below 6.5)")
#     elif ph > PH_MAX:
#         alerts.append("Water is too alkaline (High pH - above 8.5)")

#     # TDS Check
#     if tds > TDS_MAX:
#         alerts.append(f"High TDS level detected ({tds} ppm - exceeds 500 ppm)")

#     # Turbidity Check
#     if turbidity > TURBIDITY_MAX:
#         alerts.append(f"High turbidity detected ({turbidity} NTU - cloudy water)")

#     # Temperature Check (additional safety)
#     if temperature > 35:
#         alerts.append("Water temperature is unusually high")
#     elif temperature < 10:
#         alerts.append("Water temperature is unusually low")

#     # Final Status
#     if len(alerts) == 0:
#         status = "Safe"
#     elif len(alerts) <= 2:
#         status = "Moderate"
#     else:
#         status = "Unsafe"

#     return {
#         "status": status,
#         "alerts": alerts,
#         "timestamp": datetime.now()
#     }

# @app.get("/")
# def root():
#     return {"message": "Smart Water Quality Monitor API", "status": "running"}

# @app.post("/api/water-quality/check", response_model=WaterQualityResponse)
# def check_water_quality(request: WaterQualityRequest, db: Session = Depends(get_db)):
#     """
#     Check water quality and store record in database
#     """
#     try:
#         # Analyze water quality
#         result = analyze_water_quality(
#             ph=request.ph,
#             tds=request.tds,
#             turbidity=request.turbidity,
#             temperature=request.temperature
#         )
        
#         # Create database record
#         db_record = WaterQualityRecord(
#             ph_level=request.ph,
#             tds_level=request.tds,
#             turbidity_level=request.turbidity,
#             temperature=request.temperature,
#             source=request.source,
#             status=result["status"],
#             alerts=str(result["alerts"])  # Convert list to string for storage
#         )
        
#         db.add(db_record)
#         db.commit()
#         db.refresh(db_record)
        
#         # Send SMS if unsafe (you can implement actual SMS here)
#         if result["status"] == "Unsafe":
#             print(f"🚨 ALERT: Unsafe water detected at {result['timestamp']}")
#             print(f"Alerts: {result['alerts']}")
#             # TODO: Implement actual SMS sending here
        
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
#     source: str = None,  # Optional filter by source
#     limit: int = 100,     # Limit number of records
#     db: Session = Depends(get_db)
# ):
#     """
#     Get historical water quality records
#     """
#     try:
#         query = db.query(WaterQualityRecord).order_by(WaterQualityRecord.timestamp.desc())
        
#         if source:
#             query = query.filter(WaterQualityRecord.source == source)
        
#         records = query.limit(limit).all()
#         return records
    
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))

# @app.get("/api/water-quality/latest")
# def get_latest_reading(db: Session = Depends(get_db)):
#     """
#     Get the latest water quality reading
#     """
#     try:
#         latest = db.query(WaterQualityRecord).order_by(WaterQualityRecord.timestamp.desc()).first()
#         if not latest:
#             return {"message": "No records found"}
#         return latest
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))

# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)



from datetime import datetime

# BIS (Bureau of Indian Standards) Safe Drinking Limits
PH_MIN = 6.5
PH_MAX = 8.5
TDS_MAX = 500        # ppm
TURBIDITY_MAX = 5    # NTU

def analyze_water_quality(ph: float, tds: float, turbidity: float, temperature: float):
    """
    Analyze water quality based on threshold values.
    Returns:
        {
            "status": "Safe" / "Moderate" / "Unsafe",
            "alerts": [list of alert messages],
            "timestamp": current time
        }
    """

    alerts = []

    # pH Check
    if ph < PH_MIN:
        alerts.append("Water is too acidic (Low pH - below 6.5)")
    elif ph > PH_MAX:
        alerts.append("Water is too alkaline (High pH - above 8.5)")

    # TDS Check
    if tds > TDS_MAX:
        alerts.append(f"High TDS level detected ({tds} ppm - exceeds 500 ppm)")

    # Turbidity Check
    if turbidity > TURBIDITY_MAX:
        alerts.append(f"High turbidity detected ({turbidity} NTU - cloudy water)")

    # Temperature Check (additional safety)
    if temperature > 35:
        alerts.append("Water temperature is unusually high")
    elif temperature < 10:
        alerts.append("Water temperature is unusually low")

    # Final Status
    if len(alerts) == 0:
        status = "Safe"
    elif len(alerts) <= 2:
        status = "Moderate"
    else:
        status = "Unsafe"

    return {
        "status": status,
        "alerts": alerts,
        "timestamp": datetime.now()
    }