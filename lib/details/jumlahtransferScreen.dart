import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ditpolairud_petugas/settings/url_api.dart' as setting;
import 'package:http/http.dart' as http;

class JumlahTransfer extends StatefulWidget {
  @override
  _JumlahTransferState createState() => _JumlahTransferState();
}

class _JumlahTransferState extends State<JumlahTransfer> {
  TextEditingController titleController = TextEditingController();
  var loading_delik = false;

  // Ambil File
  List uploadPath = [];
  void getFilePath() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih"),
          content: Container(
              // height: 200,
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(TablerIcons.camera),
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  if (!await Permission.camera.request().isGranted) {
                    Fluttertoast.showToast(
                        msg: 'Pastikan akses kamera diaktifkan',
                        fontSize: 18,
                        gravity: ToastGravity.BOTTOM);
                  } else {
                    try {
                      var filePath = await _picker.getImage(
                        source: ImageSource.camera,
                        imageQuality: 25,
                      );
                      if (filePath == null) {
                        return;
                      }
                      setState(() {
                        // print('disiini:' + filePath.path.toString());
                        this.uploadPath.add(filePath);
                        Navigator.pop(context);
                      });
                    } on PlatformException catch (e) {
                      print("Error while picking the file: " + e.toString());
                    }
                  }
                },
                title: Text('Foto'),
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                onTap: () async {
                  try {
                    var filePath = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpeg', 'png', 'mp4', 'mpeg', 'wav'],
                    );
                    if (filePath == null) {
                      return;
                    }
                    setState(() {
                      // print('disiini:' + filePath.files.single.toString());
                      this.uploadPath.add(filePath.files.single);
                    });
                  } on PlatformException catch (e) {
                    print("Error while picking the file: " + e.toString());
                  }
                },
                title: Text('Pilih file'),
              ),
            ],
          )),
        );
      },
    );
  }

  Widget _previewImages() {
    if (uploadPath.toString() == '[]') {
      return Container();
    } else {
      return Container(
        height: 70,
        child: ListView.builder(
          itemCount: uploadPath.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: 70,
                width: 70,
                child: Stack(
                  children: [
                    Image.file(File(uploadPath[index].path), fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          print(uploadPath);
                          setState(() {
                            uploadPath.remove(uploadPath[index]);
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(Icons.close, size: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ));
          },
        ),
      );
      // return GridTile(child: Image.file(File(uploadPath), fit: BoxFit.contain));
    }
  }

  var kategoriLaporan = 'Pilih';

  void _sendLaporan() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri url = Uri.parse("api/kirim-aduan");
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + prefs.getString('token').toString()
    }, body: {
      'description': titleController.text,
      'category': kategoriLaporan,
    });
    Map<String, dynamic> _laporan;
    _laporan = json.decode(response.body);
    print(_laporan);
    if (_laporan['status_code'] == 'RD-200') {
      var i = 0;
      while (i < uploadPath.length) {
        Dio dio = new Dio();
        FormData formData = new FormData.fromMap({
          'document': await MultipartFile.fromFile(uploadPath[i].path),
        });
        var response = await dio.post(
            "api/kirim-dokumen-aduan/" + _laporan['complaint']['id'].toString(),
            data: formData,
            options: Options(headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ' + prefs.getString('token').toString()
            }));
        Map<String, dynamic> __laporan;

        __laporan = response.data;
        print(__laporan);
        i++;
      }
      Navigator.pop(context, "Done");
    } else {
      setState(() {
        loading_delik = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kirim Donasi',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          loading_delik == true
              ? MaterialButton(
                  onPressed: () {},
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Kirimkan donasi ke nomor rekening:')),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '1174101854 BNI A/N Daffa Alvi Reri',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 10,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Foto Transfer'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          getFilePath();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 40),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.2), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: Icon(
                                  TablerIcons.upload,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Upload file')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: _previewImages(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                if (titleController.text != '' &&
                    uploadPath.toString() != '[]') {
                  if (loading_delik == false) {
                    setState(() {
                      loading_delik = true;
                    });
                    await Future.delayed(Duration(seconds: 3));
                    if (kategoriLaporan == 'Pilih') {
                      print('gabisa');
                    } else {
                      _sendLaporan();
                    }
                  }
                }
              },
              child: MediaQuery.of(context).viewInsets.bottom == 0
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            loading_delik == true ? Colors.grey : Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Kirim Donasi',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
