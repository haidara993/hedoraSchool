import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/pages/widgets/LoginRoundedButton.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';
import 'package:madrasatymobile/viewmodel/auth_viewmodel.dart';

class LoginView extends GetWidget<AuthViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "LogIn",
        child: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Get.back();
        },
      ),
      floatingActionButton: LoginRoundedButton(
        label: 'Login',
        onPressed: () async {
          _formKey.currentState?.save();
          if (_formKey.currentState!.validate()) {
            controller.login();
          }
        },
      ),
      body: Stack(
        children: [
          Container(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onSaved: (newValue) {
                          controller.email = newValue;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'asd';
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintStyle: TextStyle(
                              height: 1.5, fontWeight: FontWeight.w300),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ).copyWith(
                          hintText: 'you@example.com',
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: true,
                        onSaved: (newValue) {
                          controller.password = newValue;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'asd';
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintStyle: TextStyle(
                              height: 1.5, fontWeight: FontWeight.w300),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ).copyWith(
                          hintText: 'min length is 7',
                          labelText: 'Passord',
                        ),
                      ),

                      // Hero(
                      //   tag: 'otpForget',
                      //   child: Container(
                      //     height: 50,
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: <Widget>[
                      //         ReusableRoundedButton(
                      //           child: Text(
                      //             notYetRegisteringText,
                      //             style: TextStyle(
                      //               // color: kmainColorTeacher,
                      //               fontSize: 15,
                      //             ),
                      //           ),
                      //           onPressed: () {
                      //             // _scaffoldKey.currentState.showSnackBar(
                      //             //     ksnackBar(context, 'message'));
                      //             setState(() {
                      //               if (buttonType == ButtonType.LOGIN) {
                      //                 buttonType = ButtonType.REGISTER;
                      //               } else {
                      //                 buttonType = ButtonType.LOGIN;
                      //               }
                      //               isRegistered = !isRegistered;
                      //               notYetRegisteringText = isRegistered
                      //                   ? 'Registered?'
                      //                   : 'Not Registered?';
                      //             });
                      //           },
                      //           height: 40,
                      //         ),
                      //         ReusableRoundedButton(
                      //           child: Text(
                      //             'Need Help?',
                      //             style: TextStyle(
                      //               // color: kmainColorTeacher,
                      //               fontSize: 15,
                      //             ),
                      //           ),
                      //           onPressed: () {
                      //             //Forget Password Logic
                      //             kopenPage(context, ForgotPasswordPage());
                      //           },
                      //           height: 40,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // // SizedBox(
                      //   height: 100,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // model.state == ViewState.Busy
          //     ? Container(
          //         // color: Colors.red,
          //         child: BackdropFilter(
          //           filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          //           child: kBuzyPage(color: Theme.of(context).primaryColor),
          //         ),
          //       )
          //     : Container(),
        ],
      ),
    );
  }
}
