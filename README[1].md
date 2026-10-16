# EMS Command — Shared Classroom MVP 0.2

This is a deployable starter for the EMT 911 classroom simulator. It adds a shared room code, QR join link, instructor/crew roles, synchronized dispatch board and active call, shared skill phase, findings reveal, action log, patient chat, and browser speech features.

## What works in this MVP
- Instructor creates a room with a six-character room code.
- A QR code and join URL are generated for that room.
- Students join using the room code or scanned URL.
- Instructor generates a randomized fictional dispatch board and starts a scenario.
- Room state is synchronized using Supabase Postgres changes plus a 5-second refresh fallback.
- Phases, findings reveal, action log, and chat are shared.
- Patient answers are rule-based, not an LLM/clinical decision engine.
- “Speak” uses browser speech recognition where supported; “Read latest patient reply” uses speech synthesis.
- Response and reassessment clocks display on each device. They are derived from shared timestamps.

## Important limitation
This is an MVP, not a production clinical training platform. The simple SQL policy below allows anonymous clients to read/write the classroom table. Use fictional scenarios only and do not store names, medical records, or any real patient information. For a real public deployment, replace open policies with authenticated users, instructor authorization, per-room membership checks, server-side validation, rate limiting, and audit logging. The instructor PIN in this MVP is a convenience check, not secure authentication.

## Setup and hosting

### 1. Create a Supabase project
Create a project at https://supabase.com/ and open **SQL Editor**.

### 2. Run `supabase-schema.sql`
Paste and run the contents of `supabase-schema.sql`. It creates the `ems_rooms` table, enables Realtime for updates, and adds permissive MVP policies.

### 3. Configure the website
For the fastest test, open `index.html`, click **Setup**, and enter:
- Project URL: Supabase Project Settings → API → Project URL
- anon/public key: Project Settings → API Keys → anon/public key

For a hosted class version, create `config.js` in the same folder using `config.example.js` as a template. `index.html` will read `window.EMS_CONFIG` if `config.js` is loaded. Add this line before the app's main script tag:
```html
<script src="config.js"></script>
```
Do not use the Supabase `service_role` key in browser code.

### 4. Publish the folder
Upload `index.html` (and configured `config.js`) to a static host such as Netlify, Vercel, or GitHub Pages. Because students need a URL accessible on their phones, a file opened only on your computer is not enough. Use HTTPS for microphone permissions. If using GitHub Pages, keep in mind that `config.js` is public to visitors; the anon key is designed for browser use, but the database policies must be secured before real use.

### 5. Run a classroom test
1. Instructor opens the hosted site, connects to Supabase, enters an instructor name and a classroom convenience PIN, then creates a room.
2. Instructor clicks **Generate randomized calls**.
3. Students scan the QR code or type the room code and choose a display name.
4. Instructor selects and starts a scenario; the crew can see the same dispatch and shared findings/chat.
5. Instructor reveals findings only after the crew completes the relevant assessment step.

## What needs to be built next for production
1. Real authentication and instructor/student permissions.
2. Server-side room creation and secure room membership (no client-controlled instructor role).
3. LLM-backed patient simulation with a structured, instructor-approved scenario state and deterministic vital signs.
4. Scoring rubric for NREMT-style critical criteria, with instructor review and audit history.
5. Better multi-device conflict handling, server-authoritative clocks, and reconnect/resume behavior.
6. Accessibility, privacy review, security testing, and instructor scenario editor.
7. Real-time voice conversation. Current voice is browser speech-to-text and text-to-speech, not a natural streaming AI voice.

## Clinical note
All scenarios and patient answers are fictional, simplified, and for software workflow testing. Instructors must validate assessment findings, interventions, timing, and evaluation criteria against the current curriculum and local protocols before use.
