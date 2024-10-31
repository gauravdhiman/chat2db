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
    model=OpenAIChat(model="gpt-4o-2024-08-06"),
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
        You can use the tools provided to get information about the database and run queries on it.
        Before answering or invoking tools, understand the user's intent and the data that is required to answer the question.
        For complex queries, you should be able to join multiple tables to get the required data.
        For dates, always use short readable format like Jan 1, 2024.
        For numbers, always use short readable format like 1,000,000.
        For customer names, try to keep it short with only first name and last initial.
        Whenever possible, return appropriate chart type, else markdown, else text as last option. For lists and tables, always make sure to return markdown.
        Always try to see if the query can be answered with best possible chart type else respond as simple text (markdown with tables where appropriate).
        Always respond in given structured format.
        If you think user query is not related to the database or you don't have the data to answer the question, politely and approriately say so.
        """
    ,
    response_model=DataAnalystResponseObj,
    structured_outputs=True
)