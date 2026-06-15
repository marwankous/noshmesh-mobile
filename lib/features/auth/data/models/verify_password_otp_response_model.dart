import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_response_entity.dart';

class VerifyPasswordOtpResponseModel extends VerifyPasswordOtpResponseEntity {
  const VerifyPasswordOtpResponseModel({required super.resetToken});

  factory VerifyPasswordOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyPasswordOtpResponseModel(resetToken: json['reset_token'] as String);
}
