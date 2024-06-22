import os
import shutil
from langchain.vectorstores import Chroma
import chromadb
from langchain_openai import AzureOpenAIEmbeddings
from langchain.schema import Document
import glob

# Set environment variables
os.environ["AZURE_OPENAI_API_KEY"] = "70acd5849bdd4aaaa8560815c4d929de"
os.environ["AZURE_OPENAI_ENDPOINT"] = "https://uleague-openai.openai.azure.com/"
os.environ["AZURE_OPENAI_API_VERSION"] = "2023-05-15"
os.environ["AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"] = "gpt3"

embeddings = AzureOpenAIEmbeddings(
    azure_deployment="emb_model",
    openai_api_version="2023-05-15",
)
def read_and_split_files(file_names):
    all_chunks = []
    
    for file_name in file_names:
        with open(file_name, 'r') as file:
            content = file.read()
            chunks = content.split('\n\n')
            documents = [Document(page_content=chunk, metadata={"source": file_name ,"chunk":chunk,"index":(chunks.index(chunk)+1)}) for chunk in chunks]
            all_chunks.extend(documents)
    
    return all_chunks
# Set environment variables
os.environ["AZURE_OPENAI_API_KEY"] = "70acd5849bdd4aaaa8560815c4d929de"
os.environ["AZURE_OPENAI_ENDPOINT"] = "https://uleague-openai.openai.azure.com/"
os.environ["AZURE_OPENAI_API_VERSION"] = "2023-05-15"
os.environ["AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"] = "gpt3"

embeddings = AzureOpenAIEmbeddings(
    azure_deployment="emb_model",
    openai_api_version="2023-05-15",
)

def store_data(directory_path, embeddings):
    file_names = glob.glob(os.path.join(directory_path, '*.txt'))  # Get all txt files in directory
    print(f"Found files: {file_names}")
    
    if not file_names:
        print("No files found.")
        return

    if os.path.exists('data_test'):
        shutil.rmtree('data_test')

    chunks = read_and_split_files(file_names)  # Ensure this function is defined or implemented to split files

    client = chromadb.Client()
    if not client.list_collections():
        consent_collection = client.create_collection("consent_collection")
    else:
        print("Collection already exists")

    vectordb = Chroma.from_documents(
        documents=chunks,
        embedding=embeddings,
        persist_directory="data_test"
    )
    return len(chunks)

if __name__ == "__main__":
    l=store_data('public/Questions', embeddings)
    print(l)
