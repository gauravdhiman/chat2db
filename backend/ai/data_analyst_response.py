from enum import Enum
from typing import List, Dict, Any, Optional, Union
from pydantic import BaseModel, Field

class ResponseType(str, Enum):
    CHART = "chart"
    TEXT = "text"
    MARKDOWN = "markdown"

class ChartType(str, Enum):
    BAR = "bar"
    LINE = "line"
    PIE = "pie"
    SCATTER = "scatter"

class DataPoint(BaseModel):
    x: Union[str, int, float] = Field(..., description="X-axis value depending on the data for X-Label")
    y: Optional[Dict[str, float]] = Field(None, description="Dictionary of data points with keys asname of data point and value as data point value")

class ChartConfig(BaseModel):
    chart_type: ChartType = Field(..., description="Type of the chart to be rendered")
    data: List[DataPoint] = Field(..., description="Array of data points for the chart")
    title: str = Field(..., description="Chart title")
    x_label: str = Field(..., description="X-axis label")
    y_label: str = Field(..., description="Y-axis label")

class DataAnalystResponseObj(BaseModel):
    response_type: ResponseType = Field(..., description="Type of the response (chart or text or markdown).")
    text: Optional[str] = Field(None, description="Text response when response_type is text or markdown")
    chart_config: Optional[ChartConfig] = Field(None, description="Chart configuration when response_type is chart")

    class Config:
        use_enum_values = True

    def __init__(self, **data):
        super().__init__(**data)
        if self.response_type == ResponseType.CHART and not self.chart_config:
            raise ValueError("chart_config is required when response_type is chart")
        if self.response_type == ResponseType.TEXT and not self.text:
            raise ValueError("text is required when response_type is text") 