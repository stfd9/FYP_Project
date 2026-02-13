# Forgot Password with OTP Verification

## 📧 Overview

The forgot password feature now uses **email OTP (One-Time Password) verification** for enhanced security. Users verify their identity through a 6-digit code sent to their email before they can reset their password.

---

## 🔄 Password Reset Flow

### **Step-by-Step Process:**

```
User enters email
     ↓
Check if account exists
     ↓
Send 6-digit OTP to email
     ↓
User enters OTP code
     ↓
Verify OTP (valid, expired, attempts)
     ↓
User sets new password
     ↓
Firebase reset email sent
     ↓
User clicks email link
     ↓
Password updated!
```

---

## 📁 Files Implemented

### **View Models:**
1. **`lib/ViewModel/forgot_password_view_model.dart`**
   - Handles email input and validation
   - Sends OTP via `OtpService`
   - Checks if user exists in Firestore

2. **`lib/ViewModel/forgot_password_otp_view_model.dart`**
   - Manages OTP input fields (6 digits)
   - Verifies OTP code
   - Handles resend functionality with countdown
   - Navigates to reset password on success

3. **`lib/ViewModel/reset_password_view_model.dart`** (Updated)
   - Validates new password input
   - Sends Firebase password reset email
   - Stores pending reset in Firestore

### **Views:**
1. **`lib/View/forgot_password_view.dart`** (Updated)
   - Email input screen
   - Error handling UI
   - Calls `sendOTP()` instead of direct reset

2. **`lib/View/forgot_password_otp_view.dart`** (New)
   - 6-digit OTP input UI
   - Resend code functionality
   - Countdown timer (60 seconds)
   - Error/success messages

3. **`lib/View/reset_password_view.dart`** (Existing)
   - New password input
   - Password confirmation
   - Password strength validation

---

## 🎯 How It Works

### **1. User Requests Password Reset**

**File:** `forgot_password_view.dart`

```dart
// User enters email
viewModel.sendOTP(context);
```

**What happens:**
- Validates email format
- Checks if account exists in Firestore
- Generates 6-digit OTP
- Sends email via SendGrid (using existing `OtpService`)
- OTP expires in 10 minutes
- Navigates to OTP verification screen

---

### **2. OTP Verification**

**File:** `forgot_password_otp_view.dart`

```dart
// User enters 6-digit code
viewModel.onVerifyPressed(context);
```

**Verification checks:**
- ✅ Code matches stored OTP
- ✅ Code hasn't expired (10 min limit)
- ✅ Less than 5 failed attempts
- ✅ OTP hasn't been used already

**Possible results:**
- `success` → Navigate to reset password
- `invalid` → Wrong code, try again
- `expired` → Code expired, request new one
- `too_many_attempts` → Request new code
- `not_found` → No OTP found for email

---

### **3. Set New Password**

**File:** `reset_password_view.dart`

```dart
viewModel.resetPassword(context);
```

**What happens:**
1. Validates password strength (min 6 characters)
2. Checks passwords match
3. Stores pending reset in Firestore:
   ```dart
   collection: 'pending_password_resets'
   {
     email: user@example.com,
     requestedPassword: newPassword,  // Hash in production!
     verifiedViaOTP: true,
     expiresAt: +1 hour
   }
   ```
4. Sends Firebase Auth password reset email
5. Shows success dialog with instructions

---

### **4. Complete Reset via Email**

User receives **two emails:**

1. **OTP Verification Email** (from SendGrid)
   - Contains 6-digit code
   - Expires in 10 minutes

2. **Password Reset Email** (from Firebase)
   - Standard Firebase reset link
   - User clicks to finalize password change

---

## 🔒 Security Features

### **Multi-Layer Protection:**

| Feature | Description |
|---------|-------------|
| **OTP Expiration** | Codes expire after 10 minutes |
| **Attempt Limiting** | Max 5 failed verification attempts |
| **Resend Cooldown** | 60-second wait between resends |
| **Email Verification** | Account must exist in Firestore |
| **One-Time Use** | Each OTP can only be used once |
| **Firebase Reset Link** | Final password change via secure Firebase link |

---

## 🎨 User Experience

### **Screen 1: Forgot Password**
- Clean email input field
- Error messages for invalid email
- Loading spinner during request
- "Send Code" button

### **Screen 2: OTP Verification**
- 6 individual digit input boxes
- Auto-focus next field on entry
- Resend code with countdown
- Error/success messages
- Expiration warning (10 min)

### **Screen 3: Reset Password**
- New password input (with show/hide)
- Confirm password input
- Password strength validation
- Success dialog with instructions

---

## 🧪 Testing the Flow

### **Development Testing (Without SendGrid):**

1. Leave `api_keys.dart` with placeholder API key
2. Run the app and initiate password reset
3. Check console for OTP code:
   ```
   ⚠️ WARNING: SendGrid API key not configured!
   OTP Code (for testing): 123456
   ```
4. Enter the printed OTP
5. Set new password
6. Check email for Firebase reset link

### **Production Testing (With SendGrid):**

1. Configure SendGrid API key in `lib/config/api_keys.dart`
2. Request password reset
3. Check email inbox for OTP
4. Enter 6-digit code
5. Set new password
6. Click Firebase reset link in second email
7. Login with new password

---

## 📧 Email Configuration

The forgot password flow uses **SendGrid** for OTP emails and **Firebase Auth** for final password reset.

### **SendGrid Setup:**
Already configured via `lib/config/api_keys.dart`
- See [lib/config/README.md](lib/config/README.md) for setup
- Uses same OTP service as registration

### **Firebase Auth:**
Automatically configured when you set up Firebase
- Uses default Firebase email templates
- No additional setup needed

---

## 🔧 Customization

### **Change OTP Expiration Time:**

Edit `lib/services/otp_service.dart`:
```dart
'expiresAt': DateTime.now().add(const Duration(minutes: 10)),
// Change to: Duration(minutes: 15) for 15 minutes
```

### **Change Resend Cooldown:**

Edit `lib/ViewModel/forgot_password_otp_view_model.dart`:
```dart
_resendCountdown = 60;
// Change to different seconds
```

### **Change Max Attempts:**

Edit `lib/services/otp_service.dart`:
```dart
if (attempts >= 5) {
  return 'too_many_attempts';
}
// Change 5 to different number
```

---

## ⚠️ Important Notes

### **Client-Side Limitation:**

Firebase doesn't allow password updates from the client SDK without the user being signed in. That's why we send a Firebase password reset email as the final step. 

For a fully automated solution, you would need:
- **Firebase Cloud Functions** with Admin SDK
- Backend API to update passwords directly
- Custom authentication system

### **Current Implementation:**

✅ **Pros:**
- Secure OTP email verification
- No backend/Cloud Functions needed
- Uses Firebase's secure reset mechanism
- Works with existing Firebase Auth

⚠️ **Note:**
- Users must click the Firebase reset email link to finalize
- Two emails sent (OTP + Reset link)

---

## 🚀 Future Enhancements

Potential improvements:

1. **Single-Email Solution:**
   - Implement Firebase Cloud Function
   - Update password directly after OTP verification
   - No second email needed

2. **SMS OTP Option:**
   - Add phone number verification
   - Send OTP via SMS instead of email

3. **Password Strength Meter:**
   - Visual indicator of password strength
   - Real-time feedback on password quality

4. **Security Questions:**
   - Additional verification layer
   - Backup recovery method

5. **Account Recovery Email:**
   - Send detailed recovery instructions
   - Include account activity log

---

## 📞 Support

For issues or questions:
1. Check if SendGrid API key is configured
2. Verify Firebase Authentication is enabled
3. Check email spam/junk folders
4. Test with development mode (console OTP)

---

## ✨ Summary

The OTP-based forgot password flow provides:
- ✅ Enhanced security through email verification
- ✅ User-friendly 6-digit code system
- ✅ Comprehensive error handling
- ✅ Professional UI/UX
- ✅ Works with existing SendGrid setup
- ✅ Integrates with Firebase Authentication

Users can securely reset their password with confidence! 🔐
