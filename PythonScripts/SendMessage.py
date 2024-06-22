import os
import sys
from langchain_openai import AzureOpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain_core.messages import HumanMessage
from langchain_openai import AzureChatOpenAI

# Set up environment variables
os.environ["AZURE_OPENAI_API_KEY"] = "70acd5849bdd4aaaa8560815c4d929de"
os.environ["AZURE_OPENAI_ENDPOINT"] = "https://uleague-openai.openai.azure.com/"
os.environ["AZURE_OPENAI_API_VERSION"] = "2023-05-15"
os.environ["AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"] = "gpt3"

# Set up embeddings
embeddings = AzureOpenAIEmbeddings(
    azure_deployment="emb_model",
    openai_api_version="2023-05-15",
)

db = Chroma(persist_directory="data_test", embedding_function=embeddings)

# Command line argument for query_text
query_text = sys.argv[1] if len(sys.argv) > 1 else 'How to install an eSIM?'

query_text1 = embeddings.embed_query(query_text)
results = db.similarity_search_by_vector_with_relevance_scores(query_text1, k=3)

model = AzureChatOpenAI(
    openai_api_version=os.environ["AZURE_OPENAI_API_VERSION"],
    azure_deployment=os.environ["AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"],
)

message = HumanMessage(
    content=f'''Answer the question based only on the following context:
    {results}
Answer the question based on the above context {query_text}
'''
)
response = model.invoke([message])
print(response)
