import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:veer_gatha/widgets/skeleton_loaders.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> _veers = [];
  bool _isLoading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadVeers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadVeers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('veers')
          .get();

      final list = snapshot.docs
          .map((doc) => {...doc.data(), 'docId': doc.id})
          .toList();

      if (!mounted) return;
      setState(() {
        _veers = list;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading veers for search: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _veers;

    return _veers.where((veer) {
      final name = (veer['name'] ?? '').toString().toLowerCase();
      final hindi = (veer['hindiName'] ?? '').toString().toLowerCase();
      final region = (veer['region'] ?? '').toString().toLowerCase();
      return name.contains(q) || hindi.contains(q) || region.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return AppBackground(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search Veer...',
                filled: true,
                fillColor: const Color.fromRGBO(255, 255, 255, 0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.black,
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const VeerListSkeleton()
                : results.isEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: GoogleFonts.arimo(
                        fontSize: 18,
                        color: AppColors.navy,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final veer = results[index];
                      final docId = veer['docId']?.toString() ?? '';
                      final name = veer['name']?.toString() ?? 'Unknown Veer';
                      final hindiName = veer['hindiName']?.toString() ?? '';
                      final region = veer['region']?.toString() ?? '';
                      final image = veer['imgUrl']?.toString() ?? '';

                      return GestureDetector(
                        onTap: () {
                          if (docId.isNotEmpty) context.push('/veer/$docId');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: image.isNotEmpty
                                    ? Image.network(
                                        image,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) =>
                                            _imagePlaceholder(),
                                      )
                                    : _imagePlaceholder(),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.arimo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    if (hindiName.isNotEmpty)
                                      Text(
                                        hindiName,
                                        style: GoogleFonts.arimo(
                                          fontSize: 14,
                                          color: AppColors.brown,
                                        ),
                                      ),
                                    const SizedBox(height: 5),
                                    Text(
                                      region,
                                      style: GoogleFonts.arimo(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: AppColors.brown,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: AppColors.sand,
      child: const Icon(Icons.person, size: 40),
    );
  }
}
