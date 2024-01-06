// ignore_for_file: unused_field, override_on_non_overriding_member, void_checks

import 'dart:async';
import 'dart:ffi';

import 'package:rxdart/rxdart.dart';
import 'package:tupapp/domain/model/models.dart';
import 'package:tupapp/domain/usecase/home_usecase.dart';
import 'package:tupapp/presentation/base/baseviewmodel.dart';
import 'package:tupapp/presentation/base/common/state_rendeer/state_rendeer.dart';
import 'package:tupapp/presentation/base/common/state_rendeer/state_rendeer_impl.dart';

class HomeViewModel extends BaseViewModel
    implements HomeViewModelInputs, HOmeViewModelOutputs {
  final _dataStreamController = BehaviorSubject<HomeViewObject>();

  final HomeUseCase _homeUseCase;

  HomeViewModel(
    this._homeUseCase,
  );

  @override
  void start() {
    _getHomeData();
  }

  @override
  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _homeUseCase.execute(Void)).fold(
        (failure) => {
              // left -> failure
              inputState.add(ErrorState(
                  StateRendererType.fullScreenErrorState, failure.message))
            }, (homeObject) {
      // right -> data (success)
      // content
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(homeObject.data.stores,
          homeObject.data.services, homeObject.data.banners));
      // navigate to main screen
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();

    super.dispose();
  }

// ------in put
  @override
  Sink get inputHomeData => _dataStreamController.sink;

// ------out put
  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

// input
abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

// output
abstract class HOmeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;
  HomeViewObject(this.stores, this.services, this.banners);
}
