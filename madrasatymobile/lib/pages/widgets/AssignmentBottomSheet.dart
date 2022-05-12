import 'dart:convert';
import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:madrasatymobile/helpers/ImageCompress.dart' as CompressImage;
import 'package:madrasatymobile/viewmodel/assignment_viewmodel.dart';

class AssignmentBottomSheet extends StatefulWidget {
  AssignmentBottomSheet();
  @override
  _AssignmentBottomSheetState createState() => _AssignmentBottomSheetState();
}

class _AssignmentBottomSheetState extends State<AssignmentBottomSheet> {
  TextEditingController _fileNamecontroller = TextEditingController();

  String? _fileName;
  String? _path;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isReadyToPost = false;
  bool isPosting = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _standardController = TextEditingController();
  TextEditingController _divisionController = TextEditingController();

//   Future openFileExplorer(
//     FileType _pickingType, bool mounted, BuildContext context,
//     {String? extension}) async {
//   File file;
//   if (_pickingType == FileType.image) {
//     if (extension == null) {
//       file = await CompressImage.takeCompressedPicture(context);
//       // if (file != null) _path = file.path;
//       if (!mounted) return '';

//       return file;
//     } else {
//       file = await FilePicker.getFile(type: _pickingType);
//       if (!mounted) return '';
//       return file;
//     }
//   } else if (_pickingType != FileType.custom) {
//     try {
//       file = await FilePicker.getFile(type: _pickingType);
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//     }
//     if (!mounted) return '';

//     return file;
//   } else if (_pickingType == FileType.custom) {
//     try {
//       if (extension == null) extension = 'PDF';
//       file = await FilePicker.getFile(
//           type: _pickingType, allowedExtensions: [extension]);
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//     }
//     if (!mounted) return '';
//     return file;
//   }
// }

  selectImage(parentcontext) {
    return showDialog(
      context: parentcontext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create post .."),
          children: [
            SimpleDialogOption(
              child: Text("Photo with a camera"),
              onPressed: Get.find<AssignmentViewModel>().handletakephoto,
            ),
            SimpleDialogOption(
              child: Text("Image from gallary"),
              onPressed: Get.find<AssignmentViewModel>().handlechoosephoto,
            ),
            SimpleDialogOption(
              child: Text("cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssignmentViewModel>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // if (isReadyToPost) floatingButtonPressed(model, context);
              _formKey.currentState?.save();
              if (_formKey.currentState!.validate()) {
                // controller.postAnnouncement();
              }
            },
            backgroundColor: isReadyToPost
                ? Theme.of(context).primaryColor
                : Colors.blueGrey,
            child: controller.loading == true
                ? SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 20,
                  )
                : Icon(Icons.check),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 40, left: 10, right: 10, bottom: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 40,
                      child: Text(
                        'Upload Assignment...',
                        style: TextStyle(fontWeight: FontWeight.w800)
                            .copyWith(fontSize: 20),
                      ),
                    ),
                    TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintStyle: TextStyle(
                              height: 1.5, fontWeight: FontWeight.w300),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ).copyWith(
                          hintText: string.title,
                          labelText: string.title,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      // color: Colors.blueAccent.withOpacity(0.5),
                      child: TextFormField(
                        controller: _descriptionController,
                        autocorrect: true,
                        maxLength: null,
                        maxLines: 30,
                        // expands: true,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintStyle: TextStyle(
                              height: 1.5, fontWeight: FontWeight.w300),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ).copyWith(
                          hintText: string.description_optional,
                          labelText: string.topic_description,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 300, minHeight: 0),
                      child: controller.path == 'default'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  height: 100,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Icon(FontAwesomeIcons.camera),
                                  onPressed: () async {
                                    selectImage(context);
                                  },
                                ),
                              ],
                            )
                          : Card(
                              elevation: 4,
                              child: Container(
                                // constraints:
                                //     BoxConstraints(maxHeight: 300, minHeight: 0),
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            controller.image,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -0,
                                      bottom: -0,
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: MaterialButton(
                                          minWidth: 20,
                                          height: 10,
                                          onPressed: () {
                                            controller.clearImage();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintStyle:
                            TextStyle(height: 1.5, fontWeight: FontWeight.w300),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ).copyWith(
                        hintText: 'Subject',
                        labelText: 'Subject',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _standardController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              hintStyle: TextStyle(
                                  height: 1.5, fontWeight: FontWeight.w300),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ).copyWith(
                              hintText: string.standard,
                              labelText: string.standard,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _divisionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              hintStyle: TextStyle(
                                  height: 1.5, fontWeight: FontWeight.w300),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ).copyWith(
                              labelText: string.division,
                              hintText: string.division,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
