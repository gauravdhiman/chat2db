from phi.agent import Agent
from phi.model.openai import OpenAIChat
# from phi.tools.duckduckgo import DuckDuckGo
# from phi.tools.yfinance import YFinanceTools
# from phi.knowledge.base import DatabaseKnowledgeBase
from phi.tools.postgres import PostgresTools
# from phi.vectordb.pgvector import PgVector2
# from phi.embedder.openai import OpenAIEmbedder
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
        Always try to see if the query can be answered with best possible chart type else respond as simple text (markdown with tables where appropriate).
        Always respond in given structured format.
        If you think user query is not related to the database or you don't have the data to answer the question, politely and approriately say so.
        """
    ,
    response_model=DataAnalystResponseObj,
    structured_outputs=True
)
# agent.print_response("List the tables in the database", markdown=True)

# # Load the knowledge base (comment out after first run)
# knowledge_base.load()

# # Create the data analysis agent
# data_analysis_agent = Agent(
#     name="DataAnalysisAgent",
#     role="Analyze data and generate insights",
#     model=OpenAIChat(model="gpt-4"),
#     tools=[DuckDuckGo(), YFinanceTools()],
#     knowledge_base=knowledge_base,
#     instructions=[
#         "Analyze data provided by the user",
#         "Generate insights based on the data",
#         "Suggest appropriate visualizations for the data",
#         "Use the DuckDuckGo search tool if you need additional information",
#         "Use YFinance tools for financial data",
#     ],
#     show_tool_calls=True,
# )

# Create the chart generation agent
# chart_generation_agent = Agent(
#     name="ChartGenerationAgent",
#     role="Create chart configurations for data visualizations",
#     model=OpenAIChat(model="gpt-4"),
#     knowledge_base=knowledge_base,
#     instructions=[
#         "Generate chart configurations based on the data and requirements provided",
#         "Use recharts library syntax for creating chart configurations",
#         "Provide explanations for the chart configurations you generate",
#     ],
#     show_tool_calls=True,
# )

# # Create an agent team
# agent_team = Agent(
#     name="DataVisualizationTeam",
#     team=[data_analysis_agent, chart_generation_agent],
#     instructions=[
#         "Collaborate to analyze data and create appropriate visualizations",
#         "Use tables to display data when appropriate",
#         "Always include sources for information",
#     ],
#     show_tool_calls=True,
# )

# # Function to get a response from the data analysis agent
# async def get_data_analysis_response(message: str) -> str:
#     return await data_analysis_agent.run(message)

# # Function to get a response from the chart generation agent
# async def get_chart_generation_response(message: str) -> str:
#     return await chart_generation_agent.run(message)

# # Function to get a response from the agent team
# async def get_team_response(message: str) -> str:
#     return await agent_team.run(message)
