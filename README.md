# AnuhasDev Portfolio V2

Greetings, everyone!

Allow me to present myself—I’m Anuhas Dissanayake. I’m excited to showcase my latest portfolio website project, crafted to highlight my skills and journey as a developer.

**Tech Stack used:**

- ReactJS
- Tailwind CSS
- React Router
- AOS
- Firebase
- Framer Motion
- Lucide
- Material UI
- SweetAlert2

**Website Link:**  
[https://anuhas.dev](https://anuhas.dev)

Feel free to use this project, but please give credit to the original creator, [Eki Zulfar Rachman](https://github.com/EkiZR). Thank you! 🙌

---

# Guide: Getting Started with the Project

Here’s a straightforward walkthrough to launch this project on your machine.

## Prerequisites

Make sure you have the following installed:

- **Node.js**

---

## Steps to Launch the Project

1. **Clone the Project:**

   ```bash
   git clone https://github.com/DevAnuhas/anuhas-dev-v2

   ```

2. **Install all dependencies:**

   ```bash
   npm install
   ```

   Or use:

   ```bash
   npm install --legacy-peer-deps
   ```

3. **Set environment variables:**

Create a `.env` file in the project directory and add the following environment variables:

```env
VITE_RESUME_URL=your_resume_url
VITE_WEB3_FORMS_ACCESS_KEY=your_access_key
VITE_FIREBASE_API_KEY=your_firebase_api_key
```

4. **Run the project:**

   ```bash
   npm run dev
   ```

5. **Open in browser:**

   Access the application through the link displayed in your terminal.

---

## Creating a Production Build

To create a production-ready build:

1. Run the build command:

   ```bash
   npm run build
   ```

2. The build files will be saved in the `dist` folder. You can upload this folder to your hosting server.

---

## Notes

If you encounter issues while running the project, ensure that:

- Node.js is correctly installed.
- You’re in the correct project directory.
- All dependencies are installed without errors.

---

## Firebase Configuration

To configure Firebase for this project, follow these steps:

1. **Add Firebase to the Project:**

   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Create a new project or use an existing one.

2. **Enable Firestore Database:**

   - Create a database.

3. **Go to Project Settings:**

   - Click the settings icon.
   - Copy the Firebase configuration.

4. **Go to Rules:**

   - Set the rules to `true`.

5. **Adjust the Collection Structure:**

   - Set up the collections as shown in the following images:

   ![Collection Structure Example 1](https://github.com/user-attachments/assets/38580122-08a4-4499-a8fd-0f253652a239)
   ![Collection Structure Example 2](https://github.com/user-attachments/assets/d563d7ad-f1ab-46ff-8185-640dcebd0363)

6. **Update `firebase.js` File:**
   - Replace the `firebaseConfig` content with your Firebase configuration.
