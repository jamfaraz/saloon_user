import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package_screen.dart';


class NearbyBarbars extends StatefulWidget {
  const NearbyBarbars({super.key});

  @override
  State<NearbyBarbars> createState() => _NearbyBarbarsState();
}

class _NearbyBarbarsState extends State<NearbyBarbars> {
  TextEditingController searchController = TextEditingController();
  String searchText = "";
//
//
 List<DocumentSnapshot> _lawyers = [];
  Stream<List<DocumentSnapshot>> get lawyersStream => Stream.value(_lawyers);
  bool isLoading = false;
  Future<void> _fetchNearestDonors() async {
    setState(() {
      isLoading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double userLatitude = position.latitude;
    double userLongitude = position.longitude;

    var snapshots = await FirebaseFirestore.instance
        .collection('barbars')
        .limit(4)
        .orderBy('username')
        .startAt([searchText.toUpperCase()]).endAt(['$searchText\uf8ff']).get();
    setState(() {
      _lawyers = snapshots.docs.where((doc) {
        double lawyerLatitude = doc['latitude'];
        double lawyerLongitude = doc['longitude'];
        double distance = Geolocator.distanceBetween(
          userLatitude,
          userLongitude,
          lawyerLatitude,
          lawyerLongitude,
        );
        return distance <= 10000; // 25 km in meters
      }).toList();
      setState(() {
        isLoading = false;
      });
    });
  }

 


  List<String> experience = [
    'A+',
    'B+',
    'O+',
    'AB',
    'A-',
    'B-',
    'O-',
  ];
  @override
  void initState() {
    _fetchNearestDonors();
    super.initState();
  }

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
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: Get.width * .16),
            const Text(
              'Nearby Barbars',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      hintText: 'Search for barbars',
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
             isLoading
                      ? const Padding(
                        padding: EdgeInsets.only(top: 222),
                        child: Center(
                            child:
                                CircularProgressIndicator()),
                      ) // Show loading indicator if _isLoading is true
                      : StreamBuilder<List<DocumentSnapshot>>(
                          stream: Stream.value(_lawyers),
                          builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 233),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                          child: Padding(
                        padding:  EdgeInsets.only(top: 233),
                        child: Text(
                          'No barbars Registered yet with  ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                        ),
                      ));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _lawyers.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot e = snapshot.data![index];
                          if (e["username"]
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase())) {
                            return Card(
                                shadowColor: Colors.black,
                                color: Colors.white,
                                elevation: 13,
                                child: Container(
                                  // padding:
                                  //     const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 76,
                                              decoration: ShapeDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(e['image']),
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 52),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              e['username'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              e['contact'], // Replace with your experience text
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              PackageScreen(
                                                                id: e[
                                                                    'donorId'], name: e['username'],
                                                              ));
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          height: 28,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Packages',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
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
}
