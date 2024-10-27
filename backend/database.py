from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
import os
from typing import List, Dict, Any

class Database:
    def __init__(self):
        self.engine = create_async_engine(
            os.getenv(
                "DATABASE_URL",
                "postgresql+asyncpg://user:password@localhost:5432/dataspeak"
            )
        )
        self.async_session = sessionmaker(
            self.engine, 
            class_=AsyncSession, 
            expire_on_commit=False
        )

    async def execute_query(self, query: str) -> List[Dict[str, Any]]:
        async with self.async_session() as session:
            try:
                result = await session.execute(text(query))
                return [dict(row._mapping) for row in result]
            except Exception as e:
                print(f"Database error: {str(e)}")
                raise