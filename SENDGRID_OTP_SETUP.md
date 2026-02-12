# SendGrid Email OTP Setup Guide

## 🎯 What Was Implemented

I've implemented a complete **Email OTP (One-Time Password) verification system** using SendGrid for your Flutter app. Users now receive a 6-digit code via email during registration, which they must verify before their account is created.

---

## 📦 Files Created/Modified

### **New Files:**
1. **`lib/services/otp_service.dart`** - Core OTP service (SendGrid integration)
2. **`lib/ViewModel/otp_verification_view_model.dart`** - OTP verification logic
3. **`lib/View/otp_verification_view.dart`** - OTP verification UI

### **Modified Files:**
1. **`lib/ViewModel/register_view_model.dart`** - Updated registration flow
2. **`pubspec.yaml`** - Added `http` package dependency

---

## 🔧 How It Works

### **Registration Flow:**

1. **User fills registration form** → Enters username, email, password, etc.
2. **Clicks "Register"** → System sends a 6-digit OTP to their email
3. **OTP Verification Screen** → User enters the 6-digit code
4. **Code Verified** → Firebase account created + Firestore entry added
5. **Success** → Redirected to login page

### **Technical Process:**

```
User Registration
      ↓
Generate 6-digit OTP
      ↓
Store OTP in Firestore (expires in 10 min)
      ↓
Send email via SendGrid API
      ↓
User enters OTP
      ↓
Verify against Firestore
      ↓
Create Firebase Auth + Firestore user
      ↓
Complete!
```

---

## 🚀 SendGrid Setup (Required)

### **Step 1: Create SendGrid Account**
1. Go to https://signup.sendgrid.com/
2. Sign up for FREE account (100 emails/day forever)
3. Verify your email address

### **Step 2: Get API Key**
1. Log into https://app.sendgrid.com/
2. Go to **Settings** → **API Keys**
3. Click **"Create API Key"**
4. Name: `PawScope Production` (or any name)
5. Permissions: **Full Access**
6. Click **"Create & View"**
7. **COPY THE KEY** (you won't see it again!)

### **Step 3: Verify Sender Email**
1. Go to **Settings** → **Sender Authentication**
2. Click **"Verify a Single Sender"**
3. Fill in details:
   - From Name: `PawScope`
   - From Email: Your email (e.g., `noreply@yourdomain.com` or your Gmail)
   - Reply To: Same as From Email
   - Company Address: Your address
4. Check your email and click verification link

### **Step 4: Configure Your App**

⚠️ **IMPORTANT: Never commit API keys to Git!**

1. Open **`lib/config/api_keys.dart`** (this file is git-ignored for security)
2. Update the API key and sender email:

```dart
class ApiKeys {
  // Replace with your actual SendGrid API key
  static const String sendGridApiKey = 'SG.xxxxxxxxxxxxxxxxxxxx';

  // Replace with your verified sender email
  static const String senderEmail = 'noreply@yourdomain.com';
  static const String senderName = 'PawScope';
}
```

**Example:**
```dart
class ApiKeys {
  static const String sendGridApiKey = 'SG.abc123xyz456...';
  static const String senderEmail = 'support@mypawscope.com';
  static const String senderName = 'PawScope Team';
}
```

**For New Team Members:**
- Copy `lib/config/api_keys.example.dart` to `lib/config/api_keys.dart`
- Fill in the actual values
- The file is automatically git-ignored to prevent accidental commits

---

## 🧪 Testing Without SendGrid (Development Mode)

The system works **without SendGrid configuration** for testing:

1. Leave the API key as `'YOUR_SENDGRID_API_KEY_HERE'`
2. When OTP is sent, check the **console/debug output**
3. You'll see: `⚠️ WARNING: SendGrid API key not configured!`
4. The actual OTP code will be printed: `OTP Code (for testing): 123456`
5. Use that code in the verification screen

**This allows you to test the entire flow without setting up SendGrid first!**

---

## 🎨 What The User Sees

### **Registration Screen:**
- User fills in all fields (username, email, password, etc.)
- Clicks **"Register"** button
- Loading spinner appears

### **OTP Verification Screen:**
- Shows email address where code was sent
- 6 input boxes for OTP code
- **"Verify"** button
- **"Resend"** option (available after 60 seconds)
- Error/success messages

### **Email Template:**
Users receive a beautiful HTML email with:
- 🐾 PawScope branding
- Large OTP code (easy to read)
- 10-minute expiration warning
- Professional footer

---

## 🔒 Security Features

### **Built-in Protection:**

1. **OTP Expiration**: Codes expire after 10 minutes
2. **Attempt Limiting**: Maximum 5 failed attempts per code
3. **One-time Use**: Each OTP can only be used once
4. **Resend Cooldown**: 60-second wait between resends
5. **Email Validation**: All emails stored in lowercase & trimmed

### **Firestore Structure:**

```
otps/
  └── {documentId}/
      ├── email: "user@example.com"
      ├── otp: "123456"
      ├── createdAt: Timestamp
      ├── expiresAt: Timestamp
      ├── verified: false
      └── attempts: 0
```

---

## 💰 Cost Breakdown

### **SendGrid (Email Service):**
- **Free Tier**: 100 emails/day FOREVER ✅
- **Paid Plans** (optional):
  - Essentials: $19.95/mo → 50,000 emails/month
  - Pro: $89.95/mo → 100,000 emails/month

### **Firebase (Your Blaze Plan):**
- **Cloud Firestore**: FREE up to 50K reads, 20K writes/day
- **Firebase Functions** (not used yet): FREE up to 2M invocations/month
- Your **90-day free credits** cover any tiny overages

### **For Your App:**
- 100 emails/day = **700 registrations/week** FREE
- Perfect for development, testing, and even small production launches!

---

## 🐛 Troubleshooting

### **"Failed to send verification code"**
- Check your SendGrid API key is correct
- Verify sender email is verified in SendGrid
- Check console for detailed error messages

### **"Invalid code" but code is correct**
- Code may have expired (10 minutes)
- Check Firestore `otps` collection for the exact code
- Click "Resend" to get a new code

### **Emails not arriving**
- Check spam/junk folder
- Verify sender email is verified in SendGrid
- Check SendGrid dashboard → Activity for delivery status
- Try a different recipient email (Gmail, Outlook, etc.)

### **"Too many failed attempts"**
- User entered wrong code 5+ times
- Click "Resend" to get a new code
- Old OTP will be invalidated

---

## 📱 User Experience Tips

### **Best Practices:**
1. Tell users to check spam folder
2. Show the email address where code was sent
3. Provide clear error messages
4. Allow easy resend after 60 seconds
5. Auto-focus on first OTP input field

### **Email Delivery Time:**
- SendGrid: Usually **instant** (1-3 seconds)
- Worst case: 30-60 seconds
- If > 2 minutes, user should click "Resend"

---

## 🔄 Future Enhancements (Optional)

### **Could Add:**
1. **SMS OTP** (via Twilio) as alternative
2. **Email templates** with custom branding
3. **Rate limiting** per IP address
4. **Cloud Function** to auto-clean expired OTPs
5. **Analytics** on OTP success rates

### **Cloud Function for Cleanup (Optional):**
```dart
// Run daily to delete expired OTPs
await otpService.cleanupExpiredOTPs();
```

---

## ✅ Quick Start Checklist

- [ ] Create SendGrid account
- [ ] Get SendGrid API key
- [ ] Verify sender email in SendGrid
- [ ] Update `_sendGridApiKey` in `otp_service.dart`
- [ ] Update `_senderEmail` in `otp_service.dart`
- [ ] Run `flutter pub get`
- [ ] Test registration flow
- [ ] Check email arrives
- [ ] Verify OTP works
- [ ] Test resend functionality
- [ ] Deploy to production! 🎉

---

## 📧 Support

If you encounter issues:
1. Check SendGrid Activity Feed
2. Review Firebase Firestore `otps` collection
3. Check Flutter console for error messages
4. Verify all configuration values

---

**You're all set!** The OTP system is production-ready. Just add your SendGrid credentials and you're good to go! 🚀
