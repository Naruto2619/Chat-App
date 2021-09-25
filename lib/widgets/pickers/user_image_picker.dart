import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagepick);
  final Function(File pickedimage) imagepick;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File pickedimage;
  void pickimage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      pickedimage = pickedImageFile;
    });
    widget.imagepick(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: pickedimage != null ? FileImage(pickedimage) : null,
          radius: 40,
          backgroundColor: Colors.grey,
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: pickimage,
            icon: Icon(Icons.image),
            label: Text('Add Image')),
      ],
    );
  }
}
