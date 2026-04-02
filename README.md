# 🏛️ The Legal Oracle
**An AI-Powered Legal Analysis System**

The Legal Oracle is a full-stack solution designed to bridge the gap between complex legal documentation and user accessibility. By leveraging a local Large Language Model (LLM) and a high-performance mobile interface, the system empowers users with real-time "Digital Sovereignty" and actionable document insights.

---

## 🏗️ System Architecture
The project is built upon a robust **Client-Server Architecture**, ensuring a clean separation of concerns and optimal performance:

* **Client (Flutter):** A highly responsive mobile UI that captures legal text and seamlessly handles asynchronous communication with the backend.
* **Server (FastAPI):** A high-throughput Python orchestration layer that validates incoming data and manages the AI inference lifecycle.
* **Engine (Ollama / Llama 3.2):** The core intelligence layer, performing local inference to generate and return structured legal analysis.

---

## 💻 The Tech Stack

### Frontend
* **Framework:** Flutter (Dart) for smooth, cross-platform deployment.
* **Networking:** RESTful API integration utilizing the `http` package.
* **Async Logic:** Leverages `Future` and `async/await` paradigms to guarantee a fluid, non-blocking user experience.

### Backend & AI
* **Framework:** FastAPI (Python)—optimized for speed and robust data validation via Pydantic.
* **AI Model:** Llama 3.2 (1B Parameter)—quantized to maximize inference speed while minimizing memory overhead.
* **Inference:** Ollama API wrapper for streamlined model execution.

### DevOps & Hosting
* **Containerization:** Fully Dockerized environment ensuring consistent, reproducible deployments.
* **Cloud:** Hosted on Hugging Face Spaces, backed by 16GB RAM and secured via HTTPS.

---

## 🛠️ Engineering Challenges & Solutions

* **The Memory Barrier:** Overcame strict RAM limitations by migrating from a 3B to a 1B parameter model, successfully reducing the memory footprint by 50% without compromising analytical accuracy.
* **The Network Handshake:** Resolved Android-specific security restrictions by modifying the network manifest for Cleartext Traffic and implementing robust CORS middleware within the Python backend.
* **Structured Output:** Employed precise Prompt Engineering and Regular Expressions (Regex) to constrain the LLM into returning strictly formatted JSON data, enabling the dynamic generation of organized "Flag Cards" in the UI.

---

## 🎨 Design Philosophy
The application embraces a **"Neon-Legal"** aesthetic, pairing a high-contrast dark theme with vibrant **Neon Lime (#D4FF00)** accents. This deliberate design choice visually represents the modern intersection of disruptive technology and traditional law.

---

## ⚖️ Disclaimer
This application is designed strictly as a **Decision Support Tool** and does not constitute professional legal advice. To ensure safety and reliability, it features a built-in "Risk Index" designed to flag ambiguous or high-risk areas that require formal human legal inspection.