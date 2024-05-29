import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:saloon_app/screens/dashboard/book_barber_screen.dart';

import '../../controllers/profile_controller.dart';

class PackageScreen extends StatefulWidget {
  final String id;
  final String name;
  const PackageScreen({super.key, required this.id, required this.name});

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
            const SizedBox(
              width: 34,
            ),
            Flexible(
              child: Text(
                'Packages of ${widget.name}',
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
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
            
              // const Text(
              //   'Before place booking make sure that you have to reach the salon 15 minutes ago of your selected time',
              //   style:  TextStyle(
              //       color: Colors.black,
              //       fontSize: 15
              //      ),
              // ),
              const SizedBox(
                height: 14,
              ),
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
                    
              const Text(
                'Before place booking make sure that you have to reach the salon 15 minutes ago of your selected time',
                style:  TextStyle(
                    color: Colors.black,
                    fontSize: 15
                   ),
              ),
                    const SizedBox(
                height: 8,
              ),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length ?? 0,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: Get.height * .3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                GridTile(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        // Image.network(data['itemImage']),
                                        Container(
                                          height: Get.height * .12,
                                          width: Get.size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                      topLeft: Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      data['itemImage']),
                                                  fit: BoxFit.cover)),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_pin,
                                              color: Colors.green,
                                              size: 22,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(child: Text(data['address'],overflow: TextOverflow.ellipsis,),)
                                          ],
                                        ),
                                  
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.numbers,
                                              color: Colors.green,
                                              size: 22,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(data['price'])
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.category,
                                              color: Colors.green,
                                              size: 22,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(
                                                child: Text(data['category'],overflow: TextOverflow.ellipsis))
                                          ],
                                        ),
                                  
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => BarberBookingScreen(
                                                barberId: widget.id,
                                                name: data['username'],
                                                image: data['image']));
                                          },
                                          child: Container(
                                            width: Get.width * .4,
                                            margin:
                                                 EdgeInsets.symmetric(
                                                    horizontal: Get.width*.02,
                                                    vertical: Get.height*.01),
                                            height: Get.height * .04,
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
