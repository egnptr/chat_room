import 'dart:io';

import 'package:chat_room/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ChangePhotoProfile extends StatefulWidget {
  const ChangePhotoProfile({Key key}) : super(key: key);

  @override
  _ChangePhotoProfileState createState() => _ChangePhotoProfileState();
}

class _ChangePhotoProfileState extends State<ChangePhotoProfile> {
  UploadTask uploadTask;
  File file;
  String fileName;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    fileName = file != null ? basename(file.path) : "No File Choosen";
    return Scaffold(
        appBar: AppBar(
          title: Text("Change photo profile"),
        ),
        body: Container(
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.5,
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await selectFile();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_file),
                            Text("Select File"),
                          ],
                        )),
                    Text(fileName)
                  ],
                ),
              ),
              SizedBox(
                height: 28,
              ),
              SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                    onPressed: () async {
                      await uploadFile();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file),
                        Text("Upload new photo"),
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              uploadTask != null ? buildUploadStatus(uploadTask) : Container(),
            ],
          ),
        ));
  }

  Widget buildUploadStatus(UploadTask uploadTask) =>
      StreamBuilder<TaskSnapshot>(
          stream: uploadTask.snapshotEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snapData = snapshot.data;
              final progress = snapData.bytesTransferred / snapData.totalBytes;
              final percentage = (progress * 100).toStringAsFixed(2);

              return Text("$percentage %");
            } else {
              return Container();
            }
          });

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    final path = result.files.single.path;
    setState(() {
      return file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    final destination = '/files/$fileName';

    uploadTask = Database.uploadPhotoProfile(destination, file);
    setState(() {});

    if (uploadTask == null) return;

    final snapshot = await uploadTask.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();

    Database.updateUserPhoto(urlDownload);
  }
}
