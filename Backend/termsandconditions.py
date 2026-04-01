import streamlit as st
import ollama

def analyze_tc(tc_text):
    prompt = f"""
    You are a legal expert specializing in consumer rights. 
    Analyze the following Terms and Conditions text. 
    Identify "Red Flags" (High risk) and "Yellow Flags" (Cautions).

    Please format the output as follows:
    ### 🚩 RED FLAGS
    - [Clause Name]: [Explanation]

    ### ⚠️ YELLOW FLAGS
    - [Clause Name]: [Explanation]

    ### ⚖️ SUMMARY
    A 2-sentence summary of how user-friendly these terms are.

    Terms and Conditions text:
    {tc_text}
    """

    try:
        # This calls the model running on your computer
        response = ollama.chat(model='llama3.2:3b', messages=[
            {
                'role': 'user',
                'content': prompt,
            },
        ])
        return response['message']['content']
    except Exception as e:
        return f"Error: {str(e)}. Make sure Ollama is running!"

# --- Streamlit UI ---
st.set_page_config(page_title="Free T&C Flag Finder", page_icon="⚖️")

st.title("⚖️ Local T&C Red Flag Analyzer")
st.write("This app is running 100% locally and is free forever.")

tc_input = st.text_area("Paste T&C Text here:", height=300)

if st.button("Analyze Terms"):
    if tc_input.strip() == "":
        st.warning("Please paste some text first!")
    else:
        with st.spinner("Analyzing locally... (this depends on your CPU/GPU speed)"):
            analysis = analyze_tc(tc_input)
            st.markdown("---")
            st.markdown(analysis)

st.caption("Disclaimer: No data is sent to the internet. This is for informational purposes only.")