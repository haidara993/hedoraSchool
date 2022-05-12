import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/enums/UserType.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';
import 'package:madrasatymobile/viewmodel/auth_viewmodel.dart';

class ECardView extends StatelessWidget {
  const ECardView({Key? key}) : super(key: key);

  ImageProvider<Object> setImage() {
    if (Get.find<AuthViewModel>().user?.photoUrl != 'default') {
      return NetworkImage(
        (Get.find<AuthViewModel>().user?.photoUrl)!,
      );
    } else {
      return AssetImage('assets/students.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "E-Card",
        child: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Hero(
                  tag: 'profileeee',
                  transitionOnUserGestures: true,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: setImage(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: <Widget>[
                  ProfileFieldsECard(
                    width: MediaQuery.of(context).size.width,
                    labelText: 'Student/Teacher Name',
                    initialText: Get.find<AuthViewModel>().user?.displayName,
                  ),
                  ProfileFieldsECard(
                    width: MediaQuery.of(context).size.width,
                    labelText: 'Student 0r Teacher Roll no',
                    initialText: Get.find<AuthViewModel>().user?.enrollNo,
                  ),
                  Get.find<AuthViewModel>().userType == UserType.Parent
                      ? Container()
                      : Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: ProfileFieldsECard(
                                labelText: "Standard",
                                initialText:
                                    Get.find<AuthViewModel>().user?.standard,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ProfileFieldsECard(
                                labelText: "Division",
                                initialText:
                                    Get.find<AuthViewModel>().user?.division,
                              ),
                            ),
                          ],
                        ),
                  ProfileFieldsECard(
                    width: MediaQuery.of(context).size.width,
                    labelText:
                        Get.find<AuthViewModel>().userType == UserType.Parent
                            ? "Childrens Name.."
                            : "Guardian Name",
                    initialText: Get.find<AuthViewModel>().user?.guardianName,
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ProfileFieldsECard(
                          labelText: "date of birth",
                          initialText: Get.find<AuthViewModel>().user?.dob,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ProfileFieldsECard(
                          labelText: "Blood Group",
                          initialText:
                              Get.find<AuthViewModel>().user?.bloodGroup,
                        ),
                      ),
                    ],
                  ),
                  ProfileFieldsECard(
                    width: MediaQuery.of(context).size.width,
                    labelText: "Mobile No",
                    initialText: Get.find<AuthViewModel>().user?.phoneNumber,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFieldsECard extends StatelessWidget {
  final String? initialText;
  final String? labelText;
  final double? width;

  const ProfileFieldsECard(
      {this.initialText, @required this.labelText, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      // width: width == null ? MediaQuery.of(context).size.width / 2.5 : width,
      child: TextField(
        enabled: false,
        controller: TextEditingController(text: initialText),
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintStyle: TextStyle(height: 2.0, fontWeight: FontWeight.w300),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
