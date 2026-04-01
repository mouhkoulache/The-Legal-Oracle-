from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware # <--- NEW IMPORT
from pydantic import BaseModel
import ollama
import json
import re

app = FastAPI()

# --- ADD THIS NEW SECTION FOR SECURITY ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Allows all devices (like your phone)
    allow_credentials=True,
    allow_methods=["*"], # Allows POST, GET, OPTIONS, etc.
    allow_headers=["*"],
)

class TextInput(BaseModel):
    text: str

@app.post("/analyze")
async def analyze_tc(input_data: TextInput):
    print(f"--- Analyzing New Request ({len(input_data.text)} characters) ---")
    
    # We use a 'System' message to set the persona
    # And we use 'User' to provide the text
    # We tell it NOT to use the same numbers every time.
    prompt = f"""
    You are a strict legal analyst. Analyze the following Terms and Conditions text. 
    Provide a unique risk assessment based ONLY on the provided text.
    
    Return ONLY a JSON object with this structure:
    {{
      "risk_score": (a number between 0 and 100 based on how dangerous the terms are),
      "summary": "A 2-sentence summary of these specific terms",
      "red_flags": [{{ "title": "Clause Name", "explanation": "Why it is a high risk" }}],
      "yellow_flags": [{{ "title": "Clause Name", "explanation": "Why it warrants caution" }}]
    }}

    If the text is too short or doesn't look like legal terms, give a low risk score.
    
    TEXT TO ANALYZE:
    {input_data.text[:3000]} 
    """

    try:
        print("AI is thinking...")
        response = ollama.chat(
            model='llama3.2:1b', 
            messages=[{'role': 'user', 'content': prompt}],
            options={
                "temperature": 0.7, # Adds variety to the answers
                "num_predict": 500   # Limits how long the AI talks
            }
        )
        
        raw_content = response['message']['content']
        print(f"AI Response: {raw_content}") # Watch this in your terminal!

        json_match = re.search(r'\{.*\}', raw_content, re.DOTALL)
        if json_match:
            return json.loads(json_match.group())
        else:
            return {"error": "AI failed to generate a report"}
            
    except Exception as e:
        print(f"Error: {e}")
        return {"error": str(e)}

if __name__ == "__main__":
    import uvicorn
    # Make sure host is 0.0.0.0
    uvicorn.run(app, host="0.0.0.0", port=8000)