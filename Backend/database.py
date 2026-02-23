


# from sqlalchemy import create_engine
# from sqlalchemy.orm import sessionmaker, declarative_base

# DATABASE_URL = "postgresql://postgres:Vedant1@localhost:5432/water_monitor"

# engine = create_engine(DATABASE_URL)
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
# Base = declarative_base()

# def get_db():
#     db = SessionLocal()
#     try:
#         yield db
#     finally:
#         db.close()

from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, declarative_base
import psycopg2
from psycopg2 import OperationalError

DATABASE_URL = "postgresql://postgres:Vedant1@localhost:5432/water_monitor"
db_available = False

# Test database connection first
try:
    # Test connection using psycopg2 directly
    conn = psycopg2.connect(
        host="localhost",
        database="water_monitor",
        user="postgres",
        password="Vedant1",
        port=5432
    )
    conn.close()
    print("✅ Database connection successful!")
    db_available = True
except OperationalError as e:
    print(f"❌ Database connection failed: {e}")
    print("Please check:")
    print("1. PostgreSQL is running (check Services)")
    print("2. Database 'water_monitor' exists")
    print("3. Username/password is correct")
  

# Create engine with error handling
engine = create_engine(DATABASE_URL, echo=True)  # echo=True shows SQL queries
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    except Exception as e:
        print(f"❌ Database session error: {e}")
        db.rollback()
        raise
    finally:
        db.close()