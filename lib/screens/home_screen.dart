import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/widgets/custom_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:veer_gatha/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> veersList = [];

  bool isLoading = true;

  Future<void> getVeers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("veers")
          .get();

      List<Map<String, dynamic>> tempList = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        tempList.add({...data, "docId": doc.id});
      }

      if (!mounted) return;

      setState(() {
        veersList = tempList;
        isLoading = false;
      });

      print("Veers loaded: $tempList");
    } catch (e) {
      print("Error loading veers: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getVeers();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Skeletonizer(
        enabled: isLoading,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                TextField(
                  readOnly: true,
                  onTap: () => context.push('/search'),
                  decoration: InputDecoration(
                    hintText: "Search Veer...",
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/hero.png",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 20,
                      left: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "|| स्वराज्य मेरा जन्मसिद्ध अधिकार है ||",
                            style: GoogleFonts.arimo(
                              color: AppColors.brown,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Stories That\nShaped Bharat",
                            style: GoogleFonts.arimo(
                              color: AppColors.darkNavy,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Courage. Leadership. Sacrifice.",
                            style: GoogleFonts.arimo(
                              color: AppColors.darkNavy,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {},

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Text(
                                      "EXPLORE STORY",
                                      style: GoogleFonts.arimo(
                                        color: AppColors.brown,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.brown,
                                      size: 24,
                                    ),
                                  ],
                                ),

                                Container(
                                  width: 135,
                                  height: 2,
                                  color: AppColors.brown,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore by Era",
                      style: GoogleFonts.arimo(
                        color: AppColors.darkNavy,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/eras'),
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.push('/coming-soon?title=Ancient%20India'),
                        child: CustomCard(
                          text: "Ancient India",
                          stories: "12 Stories",
                          img: "assets/images/ancient.png",
                          cardColor: Color.fromRGBO(255, 234, 205, 1),
                          borderColor: Color.fromRGBO(227, 162, 59, 1),
                        ),
                      ),

                      SizedBox(width: 18),

                      GestureDetector(
                        onTap: () =>
                            context.push('/coming-soon?title=Medieval%20India'),
                        child: CustomCard(
                          text: "Medieval India",
                          stories: "18 Stories",
                          img: "assets/images/medieval.png",
                          cardColor: Color.fromRGBO(232, 241, 239, 1),
                          borderColor: Color.fromRGBO(140, 227, 208, 1),
                        ),
                      ),

                      SizedBox(width: 18),

                      GestureDetector(
                        onTap: () => context.push(
                          '/coming-soon?title=Freedom%20Fighters',
                        ),
                        child: CustomCard(
                          text: "Freedom Fighters",
                          stories: "24 Stories",
                          img: "assets/images/freedom.png",
                          cardColor: Color.fromRGBO(234, 244, 220, 1),
                          borderColor: Color.fromRGBO(155, 175, 122, 1),
                        ),
                      ),

                      SizedBox(width: 18),

                      GestureDetector(
                        onTap: () => context.push(
                          '/coming-soon?title=Women%20of%20Valor',
                        ),
                        child: CustomCard(
                          text: "Women of Valor",
                          stories: "10 Stories",
                          img: "assets/images/women.png",
                          cardColor: Color.fromRGBO(248, 236, 232, 1),
                          borderColor: Color.fromRGBO(208, 170, 160, 1),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Featured Veers",
                      style: GoogleFonts.arimo(
                        color: AppColors.darkNavy,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/veers'),
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: isLoading ? 3 : veersList.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> veer = isLoading
                        ? {
                            "docId": "loading",
                            "imgUrl": "",
                            "region": "Maharashtra",
                            "name": "Shivaji Maharaj",
                            "description": "This is sample description...",
                            "tags": ["Warrior", "Leader"],
                          }
                        : veersList[index];

                    // DATA
                    final String docId = veer["docId"]?.toString() ?? "";
                    final String imgUrl = veer["imgUrl"]?.toString() ?? "";
                    final String region = veer["region"]?.toString() ?? "";
                    final String name = veer["name"]?.toString() ?? "No Name";
                    final String description =
                        veer["description"]?.toString() ?? "";
                    final List<dynamic> tags = veer["tags"] is List
                        ? veer["tags"] as List
                        : [];
                    return InkWell(
                      onTap: isLoading
                          ? null
                          : () {
                              if (docId.isEmpty) {
                                print("Document ID missing");
                                return;
                              }
                              print("Opening document: $docId");
                              context.push("/veer/$docId");
                            },

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(248, 236, 216, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 230,
                              width: 150,
                              child: imgUrl.isNotEmpty
                                  ? Image.network(
                                      imgUrl,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                            );
                                          },
                                    )
                                  : Container(color: Colors.grey.shade300),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          region,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: Color(0xFF040F27),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    description,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFF040F27),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  if (tags.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,

                                      child: Row(
                                        children: tags
                                            .map(
                                              (tag) => Padding(
                                                padding: EdgeInsets.only(
                                                  right: 4,
                                                ),

                                                child: Chip(
                                                  label: Text(tag.toString()),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(width: 5),

                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF040F27),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
