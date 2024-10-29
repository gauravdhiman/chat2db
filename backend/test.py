from phi.agent import Agent
from phi.tools.postgres import PostgresTools
from phi.model.openai import OpenAIChat
import os
import dotenv
from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional
from enum import Enum
import json

dotenv.load_dotenv()

db_name = os.getenv("DB_NAME")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")

class ResponseType(str, Enum):
    CHART = "chart"
    TEXT = "text"

class ChartType(str, Enum):
    BAR = "bar"
    LINE = "line"
    PIE = "pie"
    SCATTER = "scatter"

class DataPoint(BaseModel):
    x: int = Field(..., description="X-axis value. It must be provided if the response_type is chart.")
    y: int = Field(..., description="Y-axis value. It must be provided if the response_type is chart.")
    # value: int = Field(..., description="Value of the data point. It must be provided if the response_type is chart.")
    label: str | None = Field(None, description="Label of the data point. It must be provided if the response_type is chart.")

class ChartConfig(BaseModel):
    chart_type: Optional[ChartType] = Field(None, description="Type of the chart. It must be provided if the response_type is chart. the possible values are bar, line, pie, scatter.")
    data: Optional[List[DataPoint]] = Field(None, description="Data of the response. It must be provided if the response_type is chart. Ensure the data is in the correct format and not empty. Each element in array must have keys: x, y, value, label, color, etc.")
    xLabel: Optional[str] = Field(None, description="X-axis Label. It must be provided if the response_type is chart.")
    yLabel: Optional[str] = Field(None, description="Y-axis Label. It must be provided if the response_type is chart.")
    config: Optional[Dict[str, Any]] = Field(None, description="Configuration for the response. It is optional and can be provided if the response_type is chart.")

class ResponseObj(BaseModel):
    response_type: ResponseType = Field(..., description="Type of the response. Possible values are chart and text.")
    text: Optional[str] = Field(None, description="Text of the response. It must be provided if the response_type is text.")
    chart_config: Optional[ChartConfig] = Field(None, description="Configuration for the chart. It must be provided if the response_type is chart.")

agent = Agent(
    name="DBAgent",
    # model=OpenAIChat(id="gpt-4o-mini"),
    model=OpenAIChat(id="gpt-4o-2024-08-06"),
    tools=[
        PostgresTools(
            db_name=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port
        ),
    ],
    description="""You are a helpful assistant that generates the data for different 
    types of charts like for bar chart, line chart, pie chart, scatter chart etc. 
    You will be given a prompt related to some database and you will have to generate the 
    data for the chart. Charts are rendered using Recharts library. DO NOT go in loop while making function calls.""",
    # show_tool_calls=True,
    debug_mode=True,
    # markdown=True,
    structured_outputs=True,
    response_model=ResponseObj,
)

response = agent.run("show me the trendline for the number of order for each day in the last 5 days")
print('response.content >> ', response.content)
print('type(response.content) >> ', type(response.content))
