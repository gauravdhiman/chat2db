from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime
import phi
from database import Database
from query_processor import QueryProcessor
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

# Initialize API keys
phi.api_key = os.getenv('PHI_API_KEY')

app = FastAPI(title="DataSpeak API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Vite's default port
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize database connection
db = Database()
query_processor = QueryProcessor()

class QueryRequest(BaseModel):
    query: str

class QueryResponse(BaseModel):
    type: str
    data: List[Dict[str, Any]]
    xKey: str
    yKey: str

@app.post("/api/query", response_model=QueryResponse)
async def process_query(request: QueryRequest):
    try:
        # Process the natural language query
        query_intent = await query_processor.analyze_query(request.query)
        
        # Generate and execute SQL query
        sql_query = await query_processor.generate_sql(query_intent)
        raw_data = await db.execute_query(sql_query)
        
        # Transform data for visualization
        visualization_data = await query_processor.prepare_visualization(
            raw_data, 
            query_intent
        )
        
        return visualization_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app, 
        host=os.getenv('HOST', '0.0.0.0'),
        port=int(os.getenv('PORT', 4000))
    )