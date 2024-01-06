import 'package:dartz/dartz.dart';
import 'package:tupapp/data/network/failure.dart';
import 'package:tupapp/data/network/requests.dart';
import 'package:tupapp/domain/model/models.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);
  Future<Either<Failure, HomeObject>> getHomeData();
  Future<Either<Failure, StoreDetails>> getStoreDetails();
}
