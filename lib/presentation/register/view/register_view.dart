// ignore_for_file: camel_case_types, unused_field

import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tupapp/app/app_prefs.dart';
import 'package:tupapp/app/constants.dart';
import 'package:tupapp/app/di.dart';
import 'package:tupapp/presentation/base/common/state_rendeer/state_rendeer_impl.dart';
import 'package:tupapp/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:tupapp/presentation/resources/assets_manger.dart';
import 'package:tupapp/presentation/resources/color_manager.dart';
import 'package:tupapp/presentation/resources/routes_manger.dart';
import 'package:tupapp/presentation/resources/strings_manger.dart';
import 'package:tupapp/presentation/resources/values_manger.dart';

class registerView extends StatefulWidget {
  const registerView({super.key});

  @override
  State<registerView> createState() => _registerViewState();
}

class _registerViewState extends State<registerView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();

  final AppPreferences _appPreferences = instance<AppPreferences>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberEditingController =
      TextEditingController();
  _bind() {
    _viewModel.start();
    _userNameEditingController.addListener(() {
      _viewModel.setUserName(_userNameEditingController.text);
    });
    _emailEditingController.addListener(() {
      _viewModel.setPassword(_passwordEditingController.text);
    });
    _mobileNumberEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberEditingController.text);
    });
    _passwordEditingController.addListener(() {
      _viewModel.setPassword(_passwordEditingController.text);
    });
    _viewModel.isUserRegisteredInSuccessfullyStreamController.stream
        .listen((isRegistered) {
      if (isRegistered) {
        // navigate to main screen
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserRegisteredIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.register();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
        padding: const EdgeInsets.only(top: AppPadding.p28),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                    child: Image(image: AssetImage(ImageAssets.splashLogo))),
                const SizedBox(
                  height: AppSize.s28,
                ),
                //  user name
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                      stream: _viewModel.outputErrorUserName,
                      builder: (context, snapshot) {
                        return TextFormField(
                          style: TextStyle(
                              color: ColorManager.primary,
                              fontSize: AppSize.s16),
                          keyboardType: TextInputType.name,
                          controller: _userNameEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.username.tr(),
                              labelText: AppStrings.username.tr(),
                              errorText: (snapshot.data)),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p18, right: AppPadding.p28),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CountryCodePicker(
                            onChanged: (country) {
                              // update view model with code
                              _viewModel.setCountryMobileCode(
                                  country.dialCode ?? Constants.token);
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: '+20',
                            favorite: const ['+39', 'FR', '+966'],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: true,
                            // optional. aligns the flag and the Text left
                            alignLeft: true,

                            showFlag: true,
                            hideMainText: false,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: StreamBuilder<String?>(
                              stream: _viewModel.outputErrorMobileNumber,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  style: TextStyle(
                                      color: ColorManager.primary,
                                      fontSize: AppSize.s16),
                                  keyboardType: TextInputType.number,
                                  controller: _mobileNumberEditingController,
                                  decoration: InputDecoration(
                                      hintText: AppStrings.mobileNumber.tr(),
                                      labelText: AppStrings.mobileNumber.tr(),
                                      errorText: (snapshot.data)),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                // email
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                      stream: _viewModel.outputErrorEmail,
                      builder: (context, snapshot) {
                        return TextFormField(
                          style: TextStyle(
                              color: ColorManager.primary,
                              fontSize: AppSize.s16),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.emailHint.tr(),
                              labelText: AppStrings.emailHint.tr(),
                              errorText: (snapshot.data)),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                      stream: _viewModel.outputErrorPassword,
                      builder: (context, snapshot) {
                        return TextFormField(
                          style: TextStyle(
                              color: ColorManager.primary,
                              fontSize: AppSize.s16),
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.password.tr(),
                              labelText: AppStrings.password.tr(),
                              errorText: (snapshot.data)),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p28, right: AppPadding.p28),
                    child: Container(
                      height: AppSize.s40,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppSize.s8)),
                          border: Border.all(color: ColorManager.lightGrey)),
                      child: GestureDetector(
                        child: _getMediaWidget(),
                        onTap: () {
                          _showPicker(context);
                        },
                      ),
                    )),
                const SizedBox(
                  height: AppSize.s40,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outputAreAllInputsValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                      _viewModel.register();
                                      const Navigator();
                                    }
                                  : null,
                              child: Text(AppStrings.register.tr())),
                        );
                      }),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: AppPadding.p8,
                        left: AppPadding.p20,
                        right: AppPadding.p20),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppStrings.alreadyHaveAccount.tr(),
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: StreamBuilder<File>(
            stream: _viewModel.outputProfilePicture,
            builder: (context, snapshot) {
              return _imagePicketByUser(snapshot.data);
            },
          )),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc))
        ],
      ),
    );
  }

  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  trailing: const Icon(Icons.arrow_forward),
                  leading: const Icon(Icons.camera),
                  title: Text(AppStrings.photoGallery.tr()),
                  onTap: () {
                    _imageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.arrow_forward),
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: Text(AppStrings.photoCamera.tr()),
                  onTap: () {
                    _imageFromCamera();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? "") as String);
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? "") as String);
  }
}