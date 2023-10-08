import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Announcement {
  final String title;
  final String description;
  final double price;
  final String location;
  final List<String> imageUrls;

  Announcement({
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.imageUrls,
  });
}

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({Key? key}) : super(key: key);

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  final List<Announcement> announcements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(announcements[index].title),
            subtitle: Text(announcements[index].description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnnouncementDetails(announcement: announcements[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostAnnouncement(),
            ),
          ).then((newAnnouncement) {
            if (newAnnouncement != null) {
              setState(() {
                announcements.add(newAnnouncement);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PostAnnouncement extends StatefulWidget {
  const PostAnnouncement({Key? key}) : super(key: key);

  @override
  State<PostAnnouncement> createState() => _PostAnnouncementState();
}

class _PostAnnouncementState extends State<PostAnnouncement> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  List<XFile?> selectedImages = [];

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImages.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Announcement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Select Image'),
            ),
            if (selectedImages.isNotEmpty)
              Column(
                children: [
                  for (var image in selectedImages)
                    Image.file(File(image!.path)),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                final newAnnouncement = Announcement(
                  title: titleController.text,
                  description: descriptionController.text,
                  price: double.parse(priceController.text),
                  location: locationController.text,
                  imageUrls:
                      selectedImages.map((image) => image!.path).toList(),
                );
                Navigator.pop(context, newAnnouncement);
              },
              child: const Text('Post Announcement'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementDetails extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetails({required this.announcement, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${announcement.title}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Description: ${announcement.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: \$₹{announcement.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Location: ${announcement.location}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              for (var imageUrl in announcement.imageUrls)
                Image.file(File(imageUrl)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.message),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
