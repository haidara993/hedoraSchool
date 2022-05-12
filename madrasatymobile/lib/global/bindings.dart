import 'package:get/get.dart';
import 'package:madrasatymobile/viewmodel/announcement_viewmodel.dart';
import 'package:madrasatymobile/viewmodel/assignment_viewmodel.dart';
import 'package:madrasatymobile/viewmodel/auth_viewmodel.dart';
import 'package:madrasatymobile/viewmodel/control_viewmoldel.dart';
import 'package:madrasatymobile/viewmodel/home_viewmodel.dart';
import 'package:madrasatymobile/viewmodel/profile_viewmodel.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => ControlViewModel());
    Get.lazyPut(() => ProfileViewModel());
    Get.lazyPut(() => HomeViewModel());
    Get.lazyPut(() => AnnouncementViewModel());
    Get.lazyPut(() => AssignmentViewModel());
  }
}
