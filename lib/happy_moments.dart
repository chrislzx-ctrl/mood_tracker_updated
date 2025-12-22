import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_tracker/database_helper.dart';
import 'package:mood_tracker/moments_gallery_screen.dart';

class HappyMoments extends StatefulWidget {
  const HappyMoments({super.key});

  @override
  State<HappyMoments> createState() => _HappyMomentsState();
}

class _HappyMomentsState extends State<HappyMoments> {
  List<File> _moments = [];

  @override
  void initState() {
    super.initState();
    _loadMoments();
  }

  Future<void> _loadMoments() async {
    final paths = await DatabaseHelper.instance.getHappyMoments();
    setState(() {
      _moments = paths.map((path) => File(path)).toList();
    });
  }

  Future<void> _captureMoment() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await DatabaseHelper.instance.insertHappyMoment(image.path);
      _loadMoments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.sentiment_very_satisfied),
                    SizedBox(width: 8),
                    Text(
                      'Happy Moments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MomentsGalleryScreen()),
                    );
                  },
                  icon: const Icon(Icons.photo_library, size: 20),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _captureMoment,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture This Moment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_moments.length} moments captured so far',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
