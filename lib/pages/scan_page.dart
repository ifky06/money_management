import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:money_management/components/action_button.dart';
import 'package:money_management/formatter/currency_formatter.dart';
import 'package:money_management/models/action_image.dart';
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
  final storage = FirebaseStorage.instance;
  final uuid = const Uuid();
  final money = NumberFormat("#,##0", "en_US");
  // text controllers
  final newAmountController = TextEditingController();

  // action data
  ActionItem? actionData;

  ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;

  bool isLoading = false;
  final dio = Dio(BaseOptions(baseUrl: 'http://192.168.18.18:5000/'));

  Future<void> sendImage(Dio dio) async {
    setState(() {
      isLoading = true;
    });
    actionData = await ActionItem.getDataByUploadImage(
        imageFile!.path, '/perform_ocr', dio);
    if (actionData != null) {
      newAmountController.text = money.format(int.parse(actionData!.amount));
      addNewExpense();
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
    // await sendImage(dio);
    // print(await uploadImage());
  }

  Future<void> uploadImage(String idAction) async {
    setState(() {
      isLoading = true;
    });
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

      // Update action image
      final actionImage = ActionImage(
        id: '',
        imageURL: url,
        idAction: idAction,
      );
      await actionImage.addNewActionImage(actionImage);

      setState(() {
        isLoading = false;
      });

      // TODO: Simpan URL ke Firestore atau lakukan tindakan lain sesuai kebutuhan
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // add new expense
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Tambahkan Pengeluaran'),
              content: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyFormatter(),
                ],
                decoration: const InputDecoration(
                  hintText: 'Jumlah Pengeluaran',
                  icon: Text('Rp.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                controller: newAmountController,
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
    ActionItem actionItem;
    if (actionData == null) {
      actionItem = ActionItem(
        id: '',
        amount: newAmountController.text.replaceAll(",", ""),
        dateTime: DateTime.now(),
        isIncome: false,
        user: user!.email!,
      );
      await actionItem.addNewAction(actionItem);

      cancel();
    } else {
      Navigator.of(context).pop();
      actionItem = actionData!;
      String id = await actionItem.addNewActionAndGetId(actionItem);
      await uploadImage(id);

      clearControllers();
    }

    // add to firestore
  }

  // cancel new expense
  void cancel() {
    // close dialog
    Navigator.of(context).pop();

    clearControllers();
  }

  // clear controllers
  void clearControllers() {
    newAmountController.clear();
    actionData = null;
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
                  Container(
                    width: double.infinity,
                    height: 350,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: (imageFile != null)
                        ? Center(
                            child: Image.file(
                              File(imageFile!.path),
                            ),
                          )
                        : null,
                  ),
                  (imageFile != null)
                      ? ElevatedButton(
                          onPressed: () async {
                            // print(await uploadImage());
                            sendImage(dio);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeConstants.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'Scan',
                                style: TextStyle(
                                  color: ThemeConstants.primaryWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
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
                            'Loading',
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
