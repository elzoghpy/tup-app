// ignore_for_file: void_checks

import 'dart:ffi';

import 'package:rxdart/rxdart.dart';
import 'package:tupapp/domain/model/models.dart';
import 'package:tupapp/domain/usecase/store_details_usecase.dart';
import 'package:tupapp/presentation/base/baseviewmodel.dart';
import 'package:tupapp/presentation/base/common/state_rendeer/state_rendeer.dart';
import 'package:tupapp/presentation/base/common/state_rendeer/state_rendeer_impl.dart';

class StoreDetailsViewModel extends BaseViewModel
    implements StoreDetailsViewModelInput, StoreDetailsViewModelOutput {
  final _storeDetailsStreamController = BehaviorSubject<StoreDetails>();

  final StoreDetailsUseCase storeDetailsUseCase;

  StoreDetailsViewModel(this.storeDetailsUseCase);

  @override
  start() async {
    _loadData();
  }

  _loadData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await storeDetailsUseCase.execute(Void)).fold(
      (failure) {
        inputState.add(ErrorState(
            StateRendererType.fullScreenErrorState, failure.message));
      },
      (storeDetails) async {
        inputState.add(ContentState());
        inputStoreDetails.add(storeDetails);
      },
    );
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
  }

  @override
  Sink get inputStoreDetails => _storeDetailsStreamController.sink;

  //output
  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _storeDetailsStreamController.stream.map((stores) => stores);
}

abstract class StoreDetailsViewModelInput {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutput {
  Stream<StoreDetails> get outputStoreDetails;
}
