import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saloon_app/screens/dashboard/book_barber_screen.dart';

import '../../controllers/profile_controller.dart';

class PackageScreen extends StatefulWidget {
  final String id;
  const PackageScreen({super.key, required this.id});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  String searchText = "";
  TextEditingController searchController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            SizedBox(width: Get.width * .24),
            const Text(
              'Packages',
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('id', isEqualTo: widget.id)
                    .orderBy('time', descending: true)
                    .snapshots(),
                //
                //

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height * .4),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height * .4),
                      child: const Center(
                        child: Text(
                          'No package avialable yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                        ),
                      ),
                    );
                  } else {
                    //

                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length ?? 0,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                Card(
                                  shadowColor: Colors.black,
                                  color: Colors.white,
                                  elevation: 13,
                                  child: Container(
                                    // height: 166,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          const Text(
                                            'Barbar name :',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            data['username'],
                                            style: const TextStyle(
                                              color: Color(0xFF474747),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Price:',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 73,
                                            ),
                                            Text(
                                              'Rs.${data['price']}',
                                              style: const TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Address:',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 51,
                                            ),
                                            Text(
                                              data['address'],
                                              style: const TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Category:',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 44,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['category'],
                                                style: const TextStyle(
                                                  color: Color(0xFF474747),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(()=>BarberBookingScreen(barberId: widget.id, name: data['username'], image: data['image']))
                                          ;},
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: Get.width * .44),
                                            height: 34,
                                            width: Get.width * .4,
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Book now',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
