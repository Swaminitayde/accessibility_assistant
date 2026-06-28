# Accessibility Assistant

A lightweight assistant application designed to recommend assistive technologies and settings based on user queries and selected disability categories. 

The project consists of a **FastAPI backend** that processes queries using keyword matching and a **Flutter frontend** that displays the results in cards using Material 3 styling.

---

## Directory Structure

```text
accessibility_assistant/
├── backend/
│   ├── main.py            # FastAPI service
│   └── requirements.txt   # Backend dependencies
├── lib/
│   └── main.dart          # Flutter screens and API integration
├── pubspec.yaml           # Flutter settings and http library config
└── README.md              # Setup and deployment instructions (this file)
```

---

## ⚡ Setup & Run Locally

### 1. Run the FastAPI Backend

1. Navigate to the `backend/` directory in your terminal.
2. Install the Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Start the local server:
   ```bash
   uvicorn main:app --reload
   ```
   The backend will start running locally at `http://127.0.0.1:8000`.

---

### 2. Run the Flutter Frontend

1. Navigate to your project directory (`C:\Users\sushi\accessibility_assistant`) in your terminal.
2. Fetch the Flutter packages:
   ```bash
   flutter pub get
   ```
3. Start the application on your connected Android device or emulator:
   ```bash
   flutter run
   ```

*Note on Localhost Connection:*
* By default, `lib/main.dart` is configured to connect to `http://10.0.2.2:8000/recommend` (which is the loopback alias the Android Emulator uses to reach your computer's local host).
* If you are testing on a physical Android device connected via Wi-Fi, change the `backendUrl` variable at the top of `lib/main.dart` to your computer's local IP address (e.g. `http://192.168.1.50:8000/recommend`).

---

## 🚀 Deploy the Backend to Render

To make the API publicly accessible for your mobile app:

1. **Push your code to GitHub:** Create a new repository and push the entire `accessibility-assistant` project.
2. **Create a Render Service:**
   * Go to [Render](https://render.com/) and log in.
   * Click **New** in the dashboard and select **Web Service**.
   * Connect your GitHub repository containing the project.
3. **Configure Settings:**
   * **Name:** `accessibility-assistant-api` (or any custom name)
   * **Region:** Choose a region close to your user base.
   * **Branch:** `main` (or your active branch)
   * **Root Directory:** `backend`
   * **Runtime:** `Python`
   * **Build Command:** `pip install -r requirements.txt`
   * **Start Command:** `uvicorn main:app --host 0.0.0.0 --port $PORT`
4. **Deploy:** Click **Deploy Web Service**. Render will build and host your service.
5. **Connect Flutter:** Once deployed, copy your public service URL from the Render dashboard (e.g., `https://my-api-service.onrender.com`) and update the `backendUrl` constant at the top of `lib/main.dart`:
   ```dart
   const String backendUrl = 'https://my-api-service.onrender.com/recommend';
   ```
