# Firestore Setup Instructions

Your app is timing out when trying to write to Firestore. Follow these steps:

## Step 1: Check if Firestore is Enabled

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **pawscope-3b1be**
3. Click **"Firestore Database"** in the left menu
4. If you see **"Create database"** button, click it and follow the wizard:
   - Choose **"Start in test mode"** (for development)
   - Select a location (choose closest to you)
   - Click **"Enable"**

## Step 2: Update Security Rules (if database exists)

If the database already exists, the security rules might be blocking writes.

1. In Firebase Console → Firestore Database
2. Click the **"Rules"** tab
3. Replace the rules with this **temporary test configuration**:

```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // TEMPORARY: Allow all reads and writes for testing
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

4. Click **"Publish"**

⚠️ **Important**: These rules allow anyone to read/write your database. This is only for testing. Before production, implement proper authentication-based rules.

## Step 3: Test Again

After completing Step 1 or Step 2, run your Flutter app again and press the Login button.

## Expected Result

You should see in the Debug Console:
```
flutter: 🔵 Login button pressed
flutter: 🔵 Testing Firestore connection...
flutter: 🔵 Initializing Firestore with offline persistence...
flutter: ✅ Firestore settings applied
flutter: 🔵 Starting Firestore write test...
flutter: ✅ Firestore write successful!
```

## Production Security Rules (implement later)

```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Test collection (remove in production)
    match /test/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```
