from typing import Dict, List, Any
import phi
from datetime import datetime

class QueryProcessor:
    def __init__(self):
        self.phi_agent = phi.assistant(
            skills=[
                "sql_generation",
                "data_analysis",
                "visualization_selection"
            ]
        )

    async def analyze_query(self, query: str) -> Dict[str, Any]:
        """Analyze the natural language query to determine intent and requirements."""
        intent = await self.phi_agent.run(
            task="analyze_query_intent",
            args={
                "query": query,
                "context": {
                    "available_visualizations": ["line", "bar", "pie"],
                    "time_patterns": ["trend", "over time", "last", "monthly", "yearly"],
                    "comparison_patterns": ["compare", "distribution", "breakdown"],
                }
            }
        )
        return intent

    async def generate_sql(self, query_intent: Dict[str, Any]) -> str:
        """Generate SQL query based on the analyzed intent."""
        sql = await self.phi_agent.run(
            task="generate_sql_query",
            args={
                "intent": query_intent,
                "schema": await self._get_db_schema()
            }
        )
        return sql

    async def prepare_visualization(
        self,
        raw_data: List[Dict[str, Any]],
        query_intent: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Transform raw data into visualization-ready format."""
        viz_type = self._determine_visualization_type(query_intent)
        
        # Transform data based on visualization type
        if viz_type == "line":
            x_key = next(key for key in raw_data[0].keys() 
                        if any(t in key.lower() for t in ["date", "time"]))
            y_key = next(key for key in raw_data[0].keys() 
                        if key != x_key)
        elif viz_type == "pie":
            x_key = next(key for key in raw_data[0].keys() 
                        if not any(n in key.lower() for n in ["count", "sum", "total"]))
            y_key = next(key for key in raw_data[0].keys() if key != x_key)
        else:  # bar
            x_key = next(iter(raw_data[0].keys()))
            y_key = next(key for key in raw_data[0].keys() if key != x_key)

        return {
            "type": viz_type,
            "data": raw_data,
            "xKey": x_key,
            "yKey": y_key
        }

    def _determine_visualization_type(self, query_intent: Dict[str, Any]) -> str:
        """Determine the most appropriate visualization type."""
        if query_intent.get("time_series"):
            return "line"
        elif query_intent.get("distribution"):
            return "pie"
        return "bar"

    async def _get_db_schema(self) -> Dict[str, Any]:
        """Get database schema for SQL generation."""
        # This would typically fetch the actual database schema
        # For now, return a sample schema
        return {
            "tables": {
                "orders": {
                    "columns": ["id", "date", "amount", "customer_id", "product_id"]
                },
                "customers": {
                    "columns": ["id", "name", "region", "segment"]
                },
                "products": {
                    "columns": ["id", "name", "category", "price"]
                }
            }
        }