import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_score/Controllers/scanner.controller.dart';
import 'package:food_score/Controllers/user.controllers.dart';
import 'package:food_score/Core/images/general.dart';
import 'package:food_score/Core/widgets/app_button.dart';
import 'package:food_score/Core/widgets/app_snackbar.dart';
import 'package:food_score/Screens/auth/view/sign_in_screen.dart';
import 'package:food_score/Screens/user_history/user.history.dart';
import 'package:food_score/core/colors/app_colors.dart';
import 'package:food_score/core/images/app_images.dart';
import 'package:food_score/core/widgets/page_title.dart';
import 'package:food_score/Services/file.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final FileManagement _fileManagement = FileManagement();
  File? _file;
  XFile? userProfileSelect;
  String? base64ImageString;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final ScannerController _controller = Get.put(ScannerController());

  final UserController _userController = Get.put(UserController());

  void _openGallery() async {
    XFile? xFile = await _fileManagement.getPhoto(source: ImageSource.gallery);

    if (xFile != null) {
      _file = File(xFile.path);
      convertImageToBase64(xFile);
      setState(() {});
      return;
    }
    appBar(
      text: "Image not selected",
    );
  }

  void _openCamera() async {
    XFile? xFile = await _fileManagement.getPhoto(source: ImageSource.camera);
    if (xFile != null) {
      _file = File(xFile.path);
      setState(() {});
      return;
    }
    appBar(
      text: "Image not selected",
    );
  }

  void initUserData() async {
    await _userController.getUser();
    _emailController.text = _userController.user.value.email ?? " ";
    _nameController.text = _userController.user.value.fullName ?? "";
  }

  void _selectProfileImage() async {
    try {
      userProfileSelect =
          await _fileManagement.getPhoto(source: ImageSource.gallery);
      if (userProfileSelect != null) {
        _userController.userProfileSelect(userProfileSelect);
        await convertImageToBase64(userProfileSelect!);

        return;
      }
    } catch (e) {
      appBar(text: 'Image not selected\nError:$e');
    }
  }

  Future convertImageToBase64(XFile image) async {
    List<int> imageBytes = await image.readAsBytes();
    base64ImageString = base64Encode(imageBytes);
    if (base64ImageString != null) {
      _controller.scanImage(base64Image: base64ImageString!);

      Vx.log("Image converted to base 64 successfully");
    }
  }

  void _editUser() async {
    Map<String, dynamic> updateData = {
      "fullName": _nameController.text,
      "email": _emailController.text.trim().toLowerCase(),
      "image": base64ImageString,
    };

    try {
      await _userController.updateUser(updateData);
    } catch (e) {
      appBar(text: e.toString());
    }

    Get.back();
  }

  void _updatePassword() async {
    try {
      await _userController.resetPassword(
          password: _oldPasswordController.text,
          newPassword: _newPasswordController.text);
    } catch (e) {
      appBar(text: e.toString());
    } finally {
      Get.back();
      _oldPasswordController.clear();
      _newPasswordController.clear();
    }
  }

  void _logOutUser() {
    _userController.logout();
  }

  void scanFood(XFile file) async {
    try {
      await convertImageToBase64(file);

      if (base64ImageString == null) return;

      await _controller.scanImage(base64Image: base64ImageString!);
    } catch (e) {
      Vx.log("Error while scannig food  ${e.toString()}");
    }
  }

  void _deleteUser() async {
    try {
      await _userController.deleteUser(password: _oldPasswordController.text);
    } catch (e) {
      appBar(text: e.toString());
    } finally {
      Get.offAll(SignInScreen());
      _oldPasswordController.clear();
    }
  }

  @override
  void initState() {
    initUserData();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose;
    _nameController.dispose;
    _newPasswordController.dispose;
    _oldPasswordController.dispose;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Obx(() {
          return _userController.isUserLoading.value
              ? Center(child: CircularProgressIndicator.adaptive())
              : ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBrown,
                      ), //BoxDecoration
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0).copyWith(top: 50),
                      child: SizedBox(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: AppColors.buttonBackgroundGreen,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        spreadRadius: 6,
                                        color: AppColors.buttonBackgroundGreen)
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: (_userController
                                            .userProfileImage.value !=
                                        null)
                                    ? Image.memory(
                                        _userController.userProfileImage.value!,
                                        fit: BoxFit.cover,
                                        height: 90,
                                        width: 90,
                                      )
                                    : Image.asset(
                                        GeneralImage.defaultProfilePicture,
                                        fit: BoxFit.cover,
                                        width: 90,
                                        height: 90,
                                      ),
                              ),
                            ),
                            Text(
                              _userController.user.value.fullName ?? "User",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white),
                            ),
                            Text(
                              _userController.user.value.email ?? "no@mail.com",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ), //UserAccountDrawerHeader
                    ), //DrawerHeader
                    _buildDrawerItem(
                        onTap: _editUserDialogBox,
                        Icons.edit,
                        "Edit Profile",
                        context),
                    _buildDrawerItem(
                        onTap: () {}, Icons.book, "My History", context),
                    _buildDrawerItem(
                        onTap: () {},
                        Icons.workspace_premium,
                        "Go Premium",
                        context),
                    _buildDrawerItem(
                      onTap: _resetPasswordDialogBox,
                      Icons.lock_open,
                      "Reset Password",
                      context,
                    ),
                    _buildDrawerItem(
                        onTap: _logOutUser, Icons.logout, "LogOut", context),
                    _buildDrawerItem(
                      onTap: _deleteUserDialogBox,
                      Icons.person,
                      "Delete Account",
                      context,
                    ),
                  ],
                );
        }),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 224, 160, 0.2),
        title: const PageTitle(title: "Scan Food"),
        centerTitle: true,
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 12),
          alignment: Alignment.center,
          child: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              // onPressed: ()=> Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBackgroundGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.dehaze,
                // Icons.arrow_back_ios_new_sharp,
                size: 18,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () => Get.to(UserHistory()),
              // onPressed: () => Get.to(FoodInfo()),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackgroundGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              icon: const Icon(
                Icons.light_mode,
                size: 18,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Image.asset(
                    ScannerImages.scannerBackground,
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 100,
                    ),
                    Stack(
                      children: [
                        if (_file != null)
                          Container(
                            height: 340,
                            width: 300,
                            decoration: BoxDecoration(
                                color: AppColors.yellowShade,
                                borderRadius: BorderRadius.circular(24)),
                          ),
                        if (_file != null)
                          Positioned(
                            top: 20,
                            left: 10,
                            child: SizedBox(
                                height: 300,
                                width: 280,
                                child: Image.file(
                                  _file!,
                                  fit: BoxFit.contain,
                                )),
                          ),
                        Image.asset(
                          ScannerImages.scanner,
                          height: 345,
                          width: 302,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 12,
            right: 12,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.buttonBackgroundGreen,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: MediaQuery.sizeOf(context).width - 98,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.yellowShade,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          ScannerImages.selectImage,
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PageTitle(
                              title: "Scan from",
                              size: 12,
                              weight: FontWeight.w400,
                            ),
                            PageTitle(
                              title: "My Gallery",
                              size: 16,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          constraints: const BoxConstraints(
                            minHeight: 50,
                            minWidth: 50,
                          ),
                          onPressed: _openGallery,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          icon: const Icon(
                            Icons.add,
                            size: 28,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _openCamera,
                    icon: const Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context,
      {required Function() onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _editUserDialogBox() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundGreen,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Obx(
                      () => (_userController.userProfileSelect.value != null)
                          ? Image.file(
                              File(userProfileSelect!.path),
                              fit: BoxFit.cover,
                              height: 90,
                              width: 90,
                            )
                          : (_userController.userProfileImage.value != null)
                              ? Image.memory(
                                  _userController.userProfileImage.value!,
                                  fit: BoxFit.cover,
                                  height: 90,
                                  width: 90,
                                )
                              : Image.asset(
                                  GeneralImage.defaultProfilePicture,
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 8,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
                    decoration: BoxDecoration(
                        color: AppColors.buttonBackgroundGreen,
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                      onPressed: _selectProfileImage,
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.yellowShade,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                AppButton(
                  backgroundColor: AppColors.buttonBackgroundGreen,
                  onPressed: () => Get.back(),
                  text: Text(
                    "Close",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                Spacer(),
                AppButton(
                  backgroundColor: AppColors.buttonBackgroundGreen,
                  onPressed: _editUser,
                  text: Text(
                    "Save",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetPasswordDialogBox() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Old Password"),
              controller: _oldPasswordController,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "New Password",
              ),
              controller: _newPasswordController,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                AppButton(
                  backgroundColor: AppColors.buttonBackgroundGreen,
                  onPressed: () => Get.back(),
                  text: Text(
                    "Close",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                Spacer(),
                AppButton(
                  backgroundColor: AppColors.buttonBackgroundGreen,
                  onPressed: _updatePassword,
                  text: Obx(
                    () => _userController.isPasswordReseting.value
                        ? CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                          )
                        : Text(
                            "Save",
                            style: TextStyle(color: AppColors.white),
                          ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUserDialogBox() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Enter Password"),
              controller: _oldPasswordController,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                AppButton(
                  backgroundColor: AppColors.buttonBackgroundGreen,
                  onPressed: () => Get.back(),
                  text: Text(
                    "Close",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                Spacer(),
                AppButton(
                  backgroundColor: AppColors.buttonBackgroundGreen,
                  onPressed: _deleteUser,
                  text: Obx(
                    () => _userController.isPasswordReseting.value
                        ? CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                          )
                        : Text(
                            "Delete",
                            style: TextStyle(color: AppColors.white),
                          ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
