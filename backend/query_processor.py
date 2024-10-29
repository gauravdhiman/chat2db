from typing import Dict, List, Any
from ai.agents import get_data_analysis_response, get_chart_generation_response, get_team_response
import json

class QueryProcessor:
    async def analyze_query(self, query: str) -> Dict[str, Any]:
        """Analyze the natural language query to determine intent and requirements."""
        response = await get_data_analysis_response(query)
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            # If the response is not valid JSON, return a default structure
            return {
                "entities": [],
                "information_type": "unknown",
                "filters": [],
                "time_frame": None,
                "chart_type": "bar"
            }

    async def generate_sql(self, query_intent: Dict[str, Any]) -> str:
        """Generate SQL query based on the analyzed intent."""
        sql_generation_prompt = f"Generate a SQL query for the following intent: {json.dumps(query_intent)}"
        sql = await get_team_response(sql_generation_prompt)
        return sql.strip()

    async def prepare_visualization(
        self,
        raw_data: List[Dict[str, Any]],
        query_intent: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Transform raw data into visualization-ready format."""
        viz_prompt = f"""
        Given the following data and query intent, suggest the best visualization type and provide a configuration for recharts:
        Data: {json.dumps(raw_data[:5])}  # Sending only first 5 rows to avoid token limits
        Intent: {json.dumps(query_intent)}
        """
        viz_response = await get_chart_generation_response(viz_prompt)
        try:
            viz_config = json.loads(viz_response)
            return {
                "type": viz_config.get("type", "bar"),
                "data": raw_data,
                "xKey": viz_config.get("xKey", list(raw_data[0].keys())[0]),
                "yKey": viz_config.get("yKey", list(raw_data[0].keys())[1]),
                "config": viz_config.get("config", {})
            }
        except json.JSONDecodeError:
            # If the response is not valid JSON, return a default configuration
            return {
                "type": "bar",
                "data": raw_data,
                "xKey": list(raw_data[0].keys())[0],
                "yKey": list(raw_data[0].keys())[1],
                "config": {}
            }
