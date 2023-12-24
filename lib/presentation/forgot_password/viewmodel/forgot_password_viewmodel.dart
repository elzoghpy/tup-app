// ignore_for_file: unused_element, annotate_overrides, override_on_non_overriding_member

import 'dart:async';

import 'package:tupapp/app/functions.dart';
import 'package:tupapp/domain/usecase/forgot_password_usecase.dart';
import 'package:tupapp/presentation/base/baseviewmodel.dart';
import 'package:tupapp/presentation/common/state_rendeer/state_rendeer.dart';
import 'package:tupapp/presentation/common/state_rendeer/state_rendeer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel
    implements ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  var email = "";

  @override
  void start() {
    // view model should tell view please show content state
    inputState.add(ContentState());
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold((failure) {
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, failure.message));
    }, (supportMessage) {
      inputState.add(ContentState());
    });
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;
  // output
  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  Stream<bool> get outIsAllInputsValid =>
      _isAllInputValidStreamController.stream
          .map((isAllInputValid) => _IsAllInputValid());

  @override
  Stream<bool> get outIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  // ignore: non_constant_identifier_names
  _IsAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }

  @override
  Sink get _isAllInputValid => _isAllInputValidStreamController.sink;
}

abstract class ForgotPasswordViewModelInputs {
  forgotPassword();
  setEmail(String email);
  Sink get inputEmail;
  Sink get _isAllInputValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outIsEmailValid;
  Stream<bool> get outIsAllInputsValid;
}
