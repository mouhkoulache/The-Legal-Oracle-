# 🏛️ The Legal Oracle
**An AI-Powered Legal Analysis System**

The Legal Oracle is a full-stack solution designed to bridge the gap between complex legal documentation and user accessibility. [cite_start]By leveraging a local Large Language Model (LLM) and a high-performance mobile interface, the system provides real-time "Digital Sovereignty" and document insights. [cite: 5, 6, 36]

---

## 🏗️ System Architecture
[cite_start]The project follows a robust **Client-Server Architecture** to ensure separation of concerns and high performance: [cite: 2]

* [cite_start]**Client (Flutter):** A responsive mobile UI that captures legal text and handles asynchronous communication with the backend. [cite: 3, 4, 9]
* [cite_start]**Server (FastAPI):** An orchestration layer in Python that validates data and manages the AI inference lifecycle. [cite: 5, 14]
* [cite_start]**Engine (Ollama/Llama 3.2):** The intelligence layer performing local inference to return structured legal analysis. [cite: 6, 18]

---

## 💻 The Tech Stack

### Frontend
* [cite_start]**Framework:** Flutter (Dart) [cite: 8]
* [cite_start]**Networking:** RESTful API integration via the `http` package. [cite: 10]
* [cite_start]**Async Logic:** Utilizes `Future` and `async/await` for a non-blocking user experience. [cite: 9]

### Backend & AI
* [cite_start]**Framework:** FastAPI (Python) - optimized for high-performance and data validation via Pydantic. [cite: 12, 13, 14]
* [cite_start]**AI Model:** Llama 3.2 (1B Parameter) - quantized for low memory usage and speed. [cite: 16, 17]
* [cite_start]**Inference:** Ollama API wrapper. [cite: 18]

### DevOps & Hosting
* [cite_start]**Containerization:** Dockerized environment for consistent deployment. [cite: 20]
* [cite_start]**Cloud:** Hosted on Hugging Face Spaces with 16GB RAM and HTTPS security. [cite: 22]

---

## 🛠️ Engineering Challenges & Solutions

* [cite_start]**The Memory Barrier:** Overcame RAM limitations by switching from a 3B to a 1B parameter model, reducing the memory footprint by 50% while maintaining accuracy. [cite: 25]
* [cite_start]**The Network Handshake:** Resolved Android security restrictions by modifying the Manifest for Cleartext Traffic and implementing CORS middleware in the Python backend. [cite: 26]
* [cite_start]**Structured Output:** Implemented Prompt Engineering and Regular Expressions (Regex) to force the LLM to return JSON data, allowing for organized "Flag Cards" in the UI. [cite: 27]

---

## 🎨 Design Philosophy
The app features a **"Neon-Legal"** aesthetic, utilizing a high-contrast dark theme with **Neon Lime (#D4FF00)**. [cite_start]This design represents the intersection of technology and law. [cite: 35, 36]

---

## ⚖️ Disclaimer
This application is a **Decision Support Tool** and does not constitute legal advice. [cite_start]It includes a built-in "Risk Index" to identify areas requiring human legal inspection. [cite: 32]