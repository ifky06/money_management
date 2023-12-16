import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_management/components/action_button.dart';
import 'package:money_management/models/action_item.dart';
import 'package:money_management/theme/theme_constants.dart';
import 'package:uuid/uuid.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final user = FirebaseAuth.instance.currentUser;
  final saldoCollection = FirebaseFirestore.instance.collection('saldo');

  ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;
  final storage = FirebaseStorage.instance;
  final uuid = const Uuid();

  bool isLoading = false;
  final dio = Dio(BaseOptions(baseUrl: 'http://10.210.247.125:5000/'));

  Future<void> sendImage(Dio dio) async {
    setState(() {
      isLoading = true;
    });
    final actionData = await ActionItem.getDataByUploadImage(
        imageFile!.path, '/ocr_kuitansi', dio);
    if (actionData != null) {
      print(actionData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get data from server'),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickImage(ImageSource imageSource) async {
    final pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage == null) return;
    imageFile = pickedImage;
    setState(() {});
    await sendImage(dio);
    print(await uploadImage());
  }

  Future<String> uploadImage() async {
    if (imageFile == null) return '';
    try {
      final fileName = uuid.v1();
      final destination = 'images/$fileName.jpg';

      // Upload file to Firebase Storage
      await storage.ref(destination).putFile(File(imageFile!.path));
      print('selesai up image');
      // Get download URL after uploading
      final url = await storage.ref(destination).getDownloadURL();
      print('selesai get url');
      print(url);
      return url;

      // TODO: Simpan URL ke Firestore atau lakukan tindakan lain sesuai kebutuhan
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // text controllers
  final newIncomeAmountController = TextEditingController();

  // add new expense
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Tambahkan Pengeluaran'),
              content: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Pengeluaran',
                    ),
                    keyboardType: TextInputType.number,
                    controller: newIncomeAmountController,
                  ),
                ],
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
                // cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }

  // save new expense
  Future save() async {
    // create expense item
    ActionItem actionItem = ActionItem(
      id: '',
      amount: newIncomeAmountController.text,
      dateTime: DateTime.now(),
      isIncome: false,
      user: user!.email!,
    );

    // add to firestore
    await actionItem.addNewAction(actionItem);

    cancel();

    clearControllers();
  }

  // cancel new expense
  void cancel() {
    // close dialog
    Navigator.of(context).pop();

    clearControllers();
  }

  // clear controllers
  void clearControllers() {
    newIncomeAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeConstants.primaryBlue,
          title: const Center(
              child: Text(
            'Scan Kuitansi Belanja',
            style: TextStyle(
                color: ThemeConstants.primaryWhite,
                fontWeight: FontWeight.bold),
          )),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      border: Border.all(color: ThemeConstants.primaryGrey),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.arrow_forward_ios),
                      title: const Text('Manual'),
                      onTap: () {
                        addNewExpense();
                      },
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      border: Border(
                        bottom: BorderSide(color: ThemeConstants.primaryGrey),
                        left: BorderSide(color: ThemeConstants.primaryGrey),
                        right: BorderSide(color: ThemeConstants.primaryGrey),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.arrow_forward_ios),
                      title: const Text('Otomatis'),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: 100,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: ThemeConstants.primaryGrey),
                                        color: ThemeConstants.primaryGrey,
                                      ),
                                    ),
                                    const Text('Pilih metode scan'),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ActionButton(
                                              iconData: Icons.camera_alt,
                                              labelText: 'Kamera',
                                              onClick: () {
                                                pickImage(ImageSource.camera);
                                                Navigator.pop(context);
                                              }),
                                          ActionButton(
                                              iconData: Icons.image,
                                              labelText: 'Galeri',
                                              onClick: () {
                                                pickImage(ImageSource.gallery);
                                                Navigator.pop(context);
                                              }),
                                          // MaterialButton(
                                          //   onPressed: () async {
                                          //     print(await uploadImage());
                                          //   },
                                          //   child: const Text('Upload'),
                                          // ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
            (isLoading)
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Scanning KTM',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: ThemeConstants.primaryWhite,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ));
  }
}
