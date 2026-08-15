from openai import OpenAI
from dotenv import load_dotenv
import os

load_dotenv()

client = OpenAI(
    api_key=os.environ.get("LITELLM_MASTER_KEY"),
    base_url="http://localhost:4000"
)

response = client.chat.completions.create(
    model="groq-gpt-oss-120b",
    messages=[{"role": "user", "content": "Hello"}]
)
print(response.choices[0].message.content)