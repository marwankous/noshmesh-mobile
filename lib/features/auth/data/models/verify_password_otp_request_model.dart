import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_request_entity.dart';

class VerifyPasswordOtpRequestModel extends VerifyPasswordOtpRequestEntity {
  const VerifyPasswordOtpRequestModel({required super.email, required super.code});

  factory VerifyPasswordOtpRequestModel.fromEntity(VerifyPasswordOtpRequestEntity e) =>
      VerifyPasswordOtpRequestModel(email: e.email, code: e.code);

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}
