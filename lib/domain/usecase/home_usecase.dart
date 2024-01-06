import 'package:dartz/dartz.dart';
import 'package:tupapp/data/network/failure.dart';
import 'package:tupapp/data/repository/repository.dart';
import 'package:tupapp/domain/model/models.dart';
import 'package:tupapp/domain/usecase/base_usecase.dart';

class HomeUseCase implements BaseUseCase<void, HomeObject> {
  final Repository _repository;

  HomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}
