from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="Accessibility Assistant API")

# Enable CORS so our Flutter app can communicate with it
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class QueryRequest(BaseModel):
    disability_type: str
    user_query: str

@app.post("/recommend")
async def get_recommendations(request: QueryRequest):
    dtype = request.disability_type.strip().lower()
    query = request.user_query.strip().lower()

    if not dtype or not query:
        raise HTTPException(status_code=400, detail="Disability type and query are required")

    recommendations = []

    if dtype == "visual":
        if any(w in query for w in ["read", "text", "book", "screen", "see", "word"]):
            recommendations = [
                {
                    "title": "Use Screen Readers",
                    "description": "Enable TalkBack (Android) or VoiceOver (iOS) in settings to read text aloud.",
                    "icon": "record_voice_over"
                },
                {
                    "title": "Text-to-Speech Tools",
                    "description": "Install apps like Google Lookout or Seeing AI to scan and read physical documents.",
                    "icon": "document_scanner"
                }
            ]
        elif any(w in query for w in ["navigate", "walk", "go", "street", "direction"]):
            recommendations = [
                {
                    "title": "GPS Navigation Assistants",
                    "description": "Use Lazarillo or Soundscape apps designed specifically to describe surroundings and streets to blind users.",
                    "icon": "explore"
                },
                {
                    "title": "Haptic Feedback Devices",
                    "description": "Consider smart canes with ultrasonic sensors that vibrate to alert you of obstacles.",
                    "icon": "vibration"
                }
            ]
        else:
            recommendations = [
                {
                    "title": "Screen Magnification",
                    "description": "Set system display zoom and enable triple-tap screen magnification in access settings.",
                    "icon": "zoom_in"
                },
                {
                    "title": "High Contrast Mode",
                    "description": "Toggle high-contrast text and dark theme to improve readability.",
                    "icon": "contrast"
                }
            ]

    elif dtype == "mobility":
        if any(w in query for w in ["type", "keyboard", "click", "mouse", "write"]):
            recommendations = [
                {
                    "title": "Voice Access Control",
                    "description": "Install Google Voice Access to control your entire phone with spoken commands without touching the screen.",
                    "icon": "mic"
                },
                {
                    "title": "Switch Access",
                    "description": "Configure external switches or keyboard shortcuts to navigate the screen sequentially.",
                    "icon": "settings_remote"
                }
            ]
        else:
            recommendations = [
                {
                    "title": "AssistiveTouch / Easy Touch",
                    "description": "Use on-screen menus to trigger complex gestures, screenshot, or volume control with single taps.",
                    "icon": "touch_app"
                },
                {
                    "title": "External Adaptive Hardware",
                    "description": "Explore adaptive joysticks or trackballs connected via Bluetooth/OTG for precise screen control.",
                    "icon": "mouse"
                }
            ]

    elif dtype == "hearing":
        if any(w in query for w in ["hear", "listen", "video", "audio", "sound", "call"]):
            recommendations = [
                {
                    "title": "Live Captions",
                    "description": "Enable System Live Caption to generate real-time subtitles for any playing media or calls.",
                    "icon": "closed_caption"
                },
                {
                    "title": "Live Transcribe",
                    "description": "Use Google Live Transcribe to display real-time text of face-to-face conversations on your screen.",
                    "icon": "speech_to_text"
                }
            ]
        else:
            recommendations = [
                {
                    "title": "Visual Sound Notifications",
                    "description": "Turn on sound notifications to flash camera light or vibrate when smoke alarms, doorbells, or dogs bark.",
                    "icon": "flashing_lights"
                },
                {
                    "title": "Haptic Ringtone Alerts",
                    "description": "Configure distinct vibration patterns for different contacts and notifications.",
                    "icon": "vibration"
                }
            ]

    elif dtype == "cognitive":
        if any(w in query for w in ["focus", "distract", "read", "study"]):
            recommendations = [
                {
                    "title": "Reading Mode Settings",
                    "description": "Enable system Reading Mode to strip banners, ads, and visual clutter from websites, showing text-only layout.",
                    "icon": "chrome_reader_mode"
                },
                {
                    "title": "Notification Blocker",
                    "description": "Configure Focus Mode to silence distracting apps and social media during specific hours.",
                    "icon": "notifications_off"
                }
            ]
        else:
            recommendations = [
                {
                    "title": "Simplified Launchers",
                    "description": "Install a minimalist phone launcher to hide complex menus and show only essential app shortcuts.",
                    "icon": "widgets"
                },
                {
                    "title": "Routine Planners",
                    "description": "Set visual schedules and alarms with image icons to guide daily tasks sequentially.",
                    "icon": "calendar_today"
                }
            ]
    else:
        recommendations = [
            {
                "title": "General Accessibility Check",
                "description": "Open Settings > Accessibility on your device to inspect standard magnification and voice control options.",
                "icon": "accessibility"
            }
        ]

    return {"disability_type": request.disability_type, "recommendations": recommendations}
