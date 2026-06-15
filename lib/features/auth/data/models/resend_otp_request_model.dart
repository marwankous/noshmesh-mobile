import 'package:noshmesh/features/auth/domain/entities/resend_otp_request_entity.dart';

class ResendOtpRequestModel extends ResendOtpRequestEntity {
  const ResendOtpRequestModel({required super.email});

  factory ResendOtpRequestModel.fromEntity(ResendOtpRequestEntity e) =>
      ResendOtpRequestModel(email: e.email);

  Map<String, dynamic> toJson() => {'email': email};
}
