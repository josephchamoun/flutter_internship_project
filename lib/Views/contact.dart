import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/ContactController.dart';

class Contact extends StatelessWidget {
  final ContactController _contactController = Get.put(ContactController());
  Contact({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch contacts when the view is built
    _contactController.fetchContacts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (_contactController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (_contactController.contact.isEmpty) {
                return const Text('No contact information available.');
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _contactController.contact.map((contact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${contact.email}'),
                        Text('Phone: ${contact.phone}'),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                );
              }
            }),
            const SizedBox(height: 20),
            const Text(
              'Post a Message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contactController.subject,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contactController.message,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _contactController.addMessage();
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
