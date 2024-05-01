import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/user_model.dart';

class BarberBookingScreen extends StatefulWidget {
  final String barberId;
  final String name;
  final String image;
  const BarberBookingScreen(
      {super.key,
      required this.barberId,
      required this.name,
      required this.image});

  @override
  State<BarberBookingScreen> createState() => _BarberBookingScreenState();
}

class _BarberBookingScreenState extends State<BarberBookingScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  UserModel? userModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _categories = <String>[
    'Simple hair cut',
    'Fancy hair cut',
    'Beared setting',
    'Hair and beared setting',
    'Facial massag',
    'complete massage',
    'Shave',
    'Hair dryer',
  ];

  String? _category;

  void bookAppointment({
    required String category,
    required String name,
    required String date,
    required String time,
  }) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text('Please wait'), title: null);
    try {
      progressDialog.show();
      User? user = _auth.currentUser;
      String uid = user!.uid;
      var uuid = const Uuid();
      var myId = uuid.v6();
      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final data = document.data()!;
      String userName = data['username'];
      String image = data['image'];
      //
      //
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(myId)
          .set({
        'caseId': myId,
        'userId': uid,
        'barberId': widget.barberId,
        'barberImage': widget.image,
        'barberName': widget.name,
        'name': userName,
        'image': image,
        'category': category,
        'date': date,
        'time': time,
        'status': 'ongoing',
      });
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: 'Booking successful');
    } catch (e) {
      progressDialog.dismiss();

      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: Get.width * .2),
            const Text(
              'Book a Barber',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: Get.width*.022,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height*.03,
              ),
             
              Text(
                'Package',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.030,
                        horizontal: 2),
                    // prefixIcon: const Icon(Icons.category, color: Colors.black),
                    hintText: 'Select package',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black45,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                     hintStyle: const TextStyle(
                    color: Color(0xFF828A89),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                    prefixIcon: const Icon(
                      Icons.type_specimen,
                      color: Colors.redAccent,
                    )),
                value: _category,
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                items: _categories
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
              10.heightBox,
              const Text(
                'Select date',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.030,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Select a date",
                  focusColor: Colors.black,
                  hintStyle: const TextStyle(
                    color: Color(0xFF828A89),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.redAccent,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              10.heightBox,
              const Text(
                'Select a time',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.030,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Select a time",
                  focusColor: Colors.black,
                  hintStyle: const TextStyle(
                    color: Color(0xFF828A89),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.watch_later,
                    color: Colors.redAccent,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      timeController.text = picked.format(context);
                    });
                  }
                },
              ),
              SizedBox(height: Get.height * .1),
              GestureDetector(
                onTap: () async {
                  String name = nameController.text.trim();
                  String date = dateController.text.trim();
                  String time = timeController.text.trim();
                  //
                  //
          
                  if (_category.toString().isEmpty ||
                      date.isEmpty ||
                      time.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please enter all details",
                    );
                  } else {
                    bookAppointment(
                        category: _category.toString(),
                        date: date,
                        time: time,
                        name: name);
                  }
          
                  categoryController.clear();
                  timeController.clear();
                  dateController.clear();
                },
                child: Center(
                  child: Container(
                    height: 48,
                    width: Get.width,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: const Center(
                      child: Text(
                        'Book Appointment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
