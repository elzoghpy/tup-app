// ignore_for_file: unused_field, override_on_non_overriding_member, non_constant_identifier_names, unused_element

import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:tupapp/app/functions.dart';
import 'package:tupapp/domain/usecase/register_usecase.dart';
import 'package:tupapp/presentation/base/baseviewmodel.dart';
import 'package:tupapp/presentation/base/common/freezed_data_classes.dart';
import 'package:tupapp/presentation/base/common/state_rendeer/state_rendeer.dart';
import 'package:tupapp/presentation/base/common/state_rendeer/state_rendeer_impl.dart';
import 'package:tupapp/presentation/resources/strings_manger.dart';

class RegisterViewModel extends BaseViewModel
    implements RegisterViewModelInput, RegisterViewModelOutput {
  StreamController userNameStreamController =
      StreamController<String>.broadcast();
  StreamController mobileNumberStreamController =
      StreamController<String>.broadcast();
  StreamController countryMobileCodeStreamController =
      StreamController<String>.broadcast();
  StreamController emailStreamController = StreamController<String>.broadcast();
  StreamController passwordStreamController =
      StreamController<String>.broadcast();
  StreamController profilePictureStreamController =
      StreamController<File>.broadcast();
  StreamController areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  StreamController isUserRegisteredInSuccessfullyStreamController =
      StreamController<bool>();

  var registerObject = RegisterObject("", "", "", "", "", "");
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase);

  // inputs
  @override
  void dispose() {
    super.dispose();
    userNameStreamController.close();
    passwordStreamController.close();
    emailStreamController.close();
    mobileNumberStreamController.close();
    profilePictureStreamController.close();
    areAllInputsValidStreamController.close();
    isUserRegisteredInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  void start() {
    // view model should tell view please show content state
    inputState.add(ContentState());
  }

  // input

  @override
  Sink get inputPassword => passwordStreamController.sink;

  @override
  Sink get inputUserName => userNameStreamController.sink;

  @override
  Sink get inputMobileNumber => mobileNumberStreamController.sink;

  @override
  Sink get inputEmail => emailStreamController.sink;
  @override
  Sink get inputProfilePicture => profilePictureStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => areAllInputsValidStreamController.sink;

  @override
  Sink get inputAllInputsValid => areAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      //  update register view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(password: "");
    }
    validate();
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);

    if (_isUserNameValid(userName)) {
      //  update register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(userName: "");
    }
    validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (_isEmailValid(email)) {
      //  update register view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      //  update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    validate();
  }

  @override
  setCountryMobileCode(String countryMobileCode) {
    if (_isCountryMobileCodeValid(countryMobileCode)) {
      //  update register view object
      registerObject =
          registerObject.copyWith(countryMobileCode: countryMobileCode);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  @override
  setProfilePicture(String profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (_isUserNameValid(profilePicture)) {
      //  update register view object
      registerObject = registerObject.copyWith(profilePicture: profilePicture);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    validate();
  }

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _registerUseCase.execute(RegisterUseCaseInput(
            registerObject.userName,
            registerObject.password,
            registerObject.email,
            registerObject.mobileNumber,
            registerObject.profilePicture,
            registerObject.countryMobileCode)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message))
                }, (data) {
      // right -> data (success)
      // content
      inputState.add(ContentState());
      // navigate to main screen
      isUserRegisteredInSuccessfullyStreamController.add(true);
    });
  }

  // outputs
  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid.map(
      (isEmailValid) => isEmailValid ? null : AppStrings.invalidEmail.tr());

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : AppStrings.mobileNumberInvalid.tr());
  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.passwordInvalid);

  @override
  Stream<String?> get outputErrorUserName =>
      outputIsUserNameValid.map((isUserNameValid) =>
          isUserNameValid ? null : AppStrings.userNameInvalid.tr());
  @override
  Stream<String?> get outputErrorCountryMobileCode =>
      outputIsCountryMobileCodeValid.map((isCountryMobileCode) =>
          isCountryMobileCode ? null : AppStrings.mobileNumberInvalid.tr());

  @override
  Stream<bool> get outputIsEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<File> get outputProfilePicture =>
      profilePictureStreamController.stream.map((file) => file);
  @override
  Stream<bool> get outputIsPasswordValid => passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsMobileNumberValid =>
      mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<bool> get outputIsUserNameValid => userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outputIsCountryMobileCodeValid =>
      countryMobileCodeStreamController.stream.map(
          (countryMobileCode) => _isCountryMobileCodeValid(countryMobileCode));

  @override
  Stream<bool> get outputAreAllInputsValid =>
      areAllInputsValidStreamController.stream.map((_) => _areAllInputsValid());

  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _isEmailValid(String email) {
    return email.isNotEmpty;
  }

  bool _isCountryMobileCodeValid(String countryMobileCode) {
    return countryMobileCode.isNotEmpty;
  }

  bool _isProfilePictureValid(String profilePicture) {
    return profilePicture.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return registerObject.countryMobileCode.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  validate() {
    inputAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInput {
  Sink get inputUserName;

  Sink get inputMobileNumber;

  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputErrorUserName;
  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;
  Stream<bool> get outputIsCountryMobileCodeValid;
  Stream<String?> get outputErrorCountryMobileCode;
  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;
  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;
  Stream<File> get outputProfilePicture;
  Stream<bool> get outputAreAllInputsValid;
}
