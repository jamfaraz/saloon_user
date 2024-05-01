import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = "";
//
//

  String selectedCategory = ''; // 0 represents no selection

  void selectExperience(years) {
    setState(() {
      selectedCategory = years;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'All Barbers',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 1,
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
                      hintText: 'Search for barbers',
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

         

              const SizedBox(height: 12),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('barbars')
                      .orderBy('username')
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
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 233),
                        child: Text(
                          'No donors Registered yet with $selectedCategory ',
                          style: const TextStyle(
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
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          final e = snapshot.data!.docs[index];
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
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                    
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
                                                            bottom: 2),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          e['username'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                          ),
                                                        ),
                                                        Text(e['city']),
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
