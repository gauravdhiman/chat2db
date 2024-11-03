from phi.agent import Agent
from phi.model.openai import OpenAIChat
from phi.tools.postgres import PostgresTools
import os
from ai.data_analyst_response import DataAnalystResponseObj
import dotenv
dotenv.load_dotenv()

db_name = os.getenv("DB_NAME")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")

data_analysis_agent = Agent(
    name="DataAnalysisAgent",
    model=OpenAIChat(id="gpt-4o"),
    tools=[
        PostgresTools(
            db_name=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port
        ),
    ],
    show_tool_calls=True,
    description="""You are postgres expert and a helpful assistant that can answer questions based on information stored in postgres database.
        For chart responses, always structure the data points with:
        - 'x' for the x-axis value (like dates, categories)
        - 'y' as a dictionary where keys are series names (like customer names) and values are their corresponding numeric values
        For example, a data point should look like: {"x": "2024-03-01", "y": {"Customer A": 100, "Customer B": 150}}
        
        When comparing multiple entities (customers, products, etc), always include their data in the y dictionary with their names as keys.
        Do ensure that for different x values the keys in y dictionary are same. If you dont fine data for a key, put 0 in right format.
        
        For dates, always use short readable format like Jan 1, 2024.
        For numbers, always use short readable format like 1,000,000.
        For customer names, try to keep it short with only first name and last initial.
        
        Always respond in given structured format.
        If you think user query is not related to the database or you don't have the data to answer the question, politely and approriately say so.
        """
    ,
    response_model=DataAnalystResponseObj,
    structured_outputs=True
)