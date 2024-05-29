import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/profile_controller.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedCategory = '';
  String searchText = "";
//
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Bookings',
              textAlign: TextAlign.center,
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
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.heightBox,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                    controller: searchController,
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12),
                      hintText: 'Search',
                      border: InputBorder.none,
                      prefixIcon: (searchText.isEmpty)
                          ? const Icon(
                              Icons.search,
                              color: Colors.red,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                searchText = '';
                                searchController.clear();
                                setState(() {});
                              },
                            ),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    }),
              ),
              const SizedBox(height: 14),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .orderBy('barberName')
                      .where('status', isEqualTo: 'pending')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .startAt([searchText.toUpperCase()]).endAt(
                          ['$searchText\uf8ff']).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 233),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 253),
                        child: Text(
                          'You have not any booking yet',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                        ),
                      ));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          final e = snapshot.data!.docs[index];
                          final orderTime =
                              (e['orderTime'] as Timestamp).toDate();
                          final currentTime = DateTime.now();
                          final difference = currentTime.difference(orderTime);

                          String timerText = '';
                          if (e['status'] == 'pending') {
                            final minutesLeft = 30 - difference.inMinutes;
                            final secondsLeft = 60 - difference.inSeconds % 60;
                            timerText = '${minutesLeft}m ${secondsLeft}s';
                          } else {
                            timerText = e['status'];
                          }
                          // final e = snapshot.data!.docs[index];
                          if (e["barberName"]
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase())) {
                            return Column(
                              children: [
                                Card(
                                  shadowColor: Colors.black,
                                  color: Colors.white,
                                  elevation: 13,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                      leading: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          e['barberImage'],
                                        ),
                                      ),
                                      title: Text(
                                        e['barberName'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Time left: $timerText\n${e['date']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      trailing: e['status'] == 'pending'
                                          ? ElevatedButton(
                                              onPressed: () =>
                                                  _cancelOrder(e.id),
                                              child: const Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            )
                                          : null,

                                      //  TextButton(
                                      //   onPressed: () {
                                      //     showDialog(
                                      //         context: context,
                                      //         builder: (context) => AlertDialog(
                                      //               title: const Text(
                                      //                   "Are you sure ?"),
                                      //               content: const Text(
                                      //                   "Click Confirm if you want to delete this booking"),
                                      //               actions: [
                                      //                 TextButton(
                                      //                     onPressed: () {
                                      //                       Navigator.pop(
                                      //                           context);
                                      //                     },
                                      //                     child: const Text(
                                      //                         "Cancel")),
                                      //                 TextButton(
                                      //                     onPressed: () {
                                      //                       profileController
                                      //                           .deleteAppointment(
                                      //                               e.id);
                                      //                       Get.back();
                                      //                     },
                                      //                     child: const Text(
                                      //                       "Delete",
                                      //                       style: TextStyle(
                                      //                         color: Colors.red,
                                      //                       ),
                                      //                     ))
                                      //               ],
                                      //             ));
                                      //   },
                                      //   child: const Text(
                                      //     "delete",
                                      //     style: TextStyle(
                                      //       color: Colors.red,
                                      //       fontSize: 13,
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Timer? _timer;
  void _cancelOrder(String orderId) {
    FirebaseFirestore.instance.collection('appointments').doc(orderId).delete().then((_) {
      _timer?.cancel();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
