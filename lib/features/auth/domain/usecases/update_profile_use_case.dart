import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/update_profile_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/user_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute(
    UpdateProfileRequestEntity updateProfileRequest,
  ) {
    return repository.updateProfile(updateProfileRequest: updateProfileRequest);
  }
}
