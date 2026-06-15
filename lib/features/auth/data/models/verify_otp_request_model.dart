import 'package:noshmesh/features/auth/domain/entities/verify_otp_request_entity.dart';

class VerifyOtpRequestModel extends VerifyOtpRequestEntity {
  const VerifyOtpRequestModel({required super.email, required super.code});

  factory VerifyOtpRequestModel.fromEntity(VerifyOtpRequestEntity e) =>
      VerifyOtpRequestModel(email: e.email, code: e.code);

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}
