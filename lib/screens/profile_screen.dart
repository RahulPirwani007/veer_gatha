import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veer_gatha/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  bool uploading = false;

  User? get user => _auth.currentUser;

  String? savedName; // Firestore me saved naam (backup)
  StreamSubscription<User?>? _userSub;

  @override
  void initState() {
    super.initState();

    // Auth profile change hone par screen refresh ho
    _userSub = _auth.userChanges().listen((_) {
      if (mounted) setState(() {});
    });

    _loadSavedName();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedName() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final name = doc.data()?['name']?.toString().trim();

      if (!mounted || name == null || name.isEmpty) return;
      setState(() => savedName = name);
    } catch (e) {
      debugPrint('Error loading saved name: $e');
    }
  }

  Future<void> changeProfilePhoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'Profile Photo',
                  style: GoogleFonts.arimo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _PhotoOption(
                      icon: Icons.camera_alt,
                      title: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        pickImage(ImageSource.camera);
                      },
                    ),
                    _PhotoOption(
                      icon: Icons.photo_library,
                      title: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return;

      final File file = File(image.path);

      setState(() {
        selectedImage = file;
        uploading = true;
      });

      await uploadProfilePhoto(file);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Photo select nahi ho paayi: $e')));
    }
  }

  Future<void> uploadProfilePhoto(File file) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${currentUser.uid}.jpg');

      await storageRef.putFile(file);

      final String downloadUrl = await storageRef.getDownloadURL();

      await currentUser.updatePhotoURL(downloadUrl);
      await currentUser.reload();

      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile photo updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Photo upload failed: $e')));
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();

      if (!mounted) return;

      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = user;

    final String email = currentUser?.email ?? '';

    // Pehle account banate time diya naam, warna Firestore ka naam,
    // warna email ka pehla hissa.
    final String userName = currentUser?.displayName?.trim().isNotEmpty == true
        ? currentUser!.displayName!.trim()
        : (savedName?.isNotEmpty == true
              ? savedName!
              : (email.contains('@') ? email.split('@').first : 'User'));

    ImageProvider profileImage;

    if (selectedImage != null) {
      profileImage = FileImage(selectedImage!);
    } else if (currentUser?.photoURL != null) {
      profileImage = NetworkImage(currentUser!.photoURL!);
    } else {
      profileImage = AssetImage('assets/images/user.png');
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 25, 20, 30),
      child: Column(
        children: [
          GestureDetector(
            onTap: uploading ? null : changeProfilePhoto,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundColor: AppColors.sand,
                  backgroundImage: profileImage,
                ),

                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: uploading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.camera_alt, color: Colors.white, size: 25),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          Text(
            userName,
            textAlign: TextAlign.center,
            style: GoogleFonts.arimo(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),

          SizedBox(height: 8),

          Text(
            email,
            textAlign: TextAlign.center,
            style: GoogleFonts.arimo(fontSize: 16, color: Colors.black54),
          ),

          SizedBox(height: 50),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  leading: Icon(
                    Icons.bookmark_outline,
                    color: AppColors.brown,
                    size: 30,
                  ),
                  title: Text(
                    'Saved Veers',
                    style: GoogleFonts.arimo(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    context.go('/saved');
                  },
                ),

                Divider(),

                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  leading: Icon(
                    Icons.description_outlined,
                    color: AppColors.brown,
                    size: 30,
                  ),
                  title: Text(
                    'Terms & Condition',
                    style: GoogleFonts.arimo(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    context.push('/terms');
                  },
                ),

                Divider(),

                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  leading: Icon(Icons.logout, color: AppColors.brown, size: 30),
                  title: Text('Logout', style: GoogleFonts.arimo(fontSize: 18)),
                  onTap: logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PhotoOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: AppColors.brown),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.arimo(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
