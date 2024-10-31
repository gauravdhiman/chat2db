from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
# from typing import Optional, List, Dict, Any
# from datetime import datetime
# import phi
# from database import Database
# from query_processor import QueryProcessor
from dotenv import load_dotenv
import os
from ai.agents import data_analysis_agent
from ai.data_analyst_response import DataAnalystResponseObj
# Load environment variables
load_dotenv()

app = FastAPI(title="Chat2DB API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=[os.getenv('FRONTEND_URL', '')],
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

class QueryRequest(BaseModel):
    query: str

@app.post("/api/query", response_model=DataAnalystResponseObj)
async def process_query(request: QueryRequest):
    # try:
    response = data_analysis_agent.run(request.query)        
    return response.content.dict()
    # except Exception as e:
    #     print(f"Error processing query: {str(e)}")
    #     raise HTTPException(status_code=500, detail=str(e))

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