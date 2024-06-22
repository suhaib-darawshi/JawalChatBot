import os
import shutil
from langchain_community.vectorstores import Chroma
import chromadb
from langchain.schema import Document
from langchain_core.messages import HumanMessage
from langchain_openai import AzureChatOpenAI
import json
import sys
os.environ["AZURE_OPENAI_API_KEY"] = "70acd5849bdd4aaaa8560815c4d929de"
os.environ["AZURE_OPENAI_ENDPOINT"] = "https://uleague-openai.openai.azure.com/"
os.environ["AZURE_OPENAI_API_VERSION"] = "2023-05-15"
os.environ["AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"] = "gpt3"



from langchain_openai import AzureOpenAIEmbeddings

embeddings = AzureOpenAIEmbeddings(
    azure_deployment="emb_model",
    openai_api_version="2023-05-15",
)


db = Chroma(persist_directory="data_test", embedding_function=embeddings)

query_text = sys.argv[1] if len(sys.argv) > 1 else 'How to install an eSIM?'
query_vector = embeddings.embed_query(query_text)
results = db.similarity_search_by_vector_with_relevance_scores(query_vector, k=3)

smallest_score = 10
smallest_score_source = ''
final_metadata={}
for result, score in results:
    if smallest_score > score:
        smallest_score = score
        smallest_score_source = result.metadata['source']
        final_metadata=result.metadata

from langchain_core.messages import HumanMessage
from langchain_openai import AzureChatOpenAI

model = AzureChatOpenAI(
    openai_api_version=os.environ["AZURE_OPENAI_API_VERSION"],
    azure_deployment=os.environ["AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"],
)

context = "\n\n".join([result.page_content for result, score in results])
message = HumanMessage(
    content=f'''I start a new position at JAWWAL as a technical support employee,
     and the company needs me to answer on the Subscriber questions using their application.
     The Subscriber question is: {query_text}, 
     and I need you to answer on it according to this information: {results}.
The answer should be well formatted and it should use appropriate words like: Dear Subscriber and so on without any names or any personal information and make it as a bot answer.
If the information provided did not directly address the query or it's not related to the question, return 'No' ONLY as an answer.
'''
)
response = model.invoke([message])
if smallest_score > 1:
    res = {
        "answer": "No",
        "source": ''
    }
else: 
    res = {
    "answer": response.json(),
    "source": smallest_score_source,
    "metadata":final_metadata
}
json_string = json.dumps(res)
print(json_string)