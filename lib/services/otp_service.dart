import 'package:email_otp/email_otp.dart';

class OtpService {
  // 1. Create a single instance for the whole app
  static final EmailOTP _auth = EmailOTP();

  // 2. Getter to access this instance
  static EmailOTP get auth => _auth;

  // 3. Helper to setup configuration
  static void configure({required String email}) {
    _auth.setConfig(
      appEmail: "support@pawscope.com", // Replace with your app email
      appName: "PawScope",
      userEmail: email,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );
  }
}
