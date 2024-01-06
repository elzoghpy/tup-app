import 'package:dartz/dartz.dart';
import 'package:tupapp/data/network/failure.dart';
import 'package:tupapp/data/repository/repository.dart';
import 'package:tupapp/domain/model/models.dart';
import 'package:tupapp/domain/usecase/base_usecase.dart';

class StoreDetailsUseCase extends BaseUseCase<void, StoreDetails> {
  Repository repository;

  StoreDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) {
    return repository.getStoreDetails();
  }
}
