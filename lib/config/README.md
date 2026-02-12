# API Configuration Setup

## For Team Members / New Developers

The `api_keys.dart` file is **git-ignored** for security. You need to create it locally:

### Setup Steps:

1. **Copy the example file:**
   ```bash
   cd lib/config
   cp api_keys.example.dart api_keys.dart
   ```

2. **Open `api_keys.dart` and update with actual values:**
   - Get the SendGrid API key from a team member or project admin
   - Update the `sendGridApiKey` value
   - Verify the `senderEmail` and `senderName` are correct

3. **The file should look like:**
   ```dart
   class ApiKeys {
     static const String sendGridApiKey = 'SG.actual_key_here...';
     static const String senderEmail = 'pawscope1@outlook.com';
     static const String senderName = 'PawScope Support';
   }
   ```

4. **Done!** Your local setup is complete.

### Important Notes:

- ✅ `api_keys.dart` is git-ignored - your keys stay private
- ✅ `api_keys.example.dart` is committed - team members know what to configure
- ⚠️ **Never commit** `api_keys.dart` to version control
- ⚠️ Each developer can use their own SendGrid API key if needed

### Getting Your Own SendGrid API Key (Optional):

If you want to use your own key instead of the shared one:

1. Sign up at https://signup.sendgrid.com/ (free tier available)
2. Verify your email
3. Go to Settings → API Keys → Create API Key
4. Copy the key and paste it in your local `api_keys.dart`
5. Verify a sender email at Settings → Sender Authentication

### Need Help?

Ask a team member for:
- The current SendGrid API key
- Verified sender email details
- Any other configuration values
