import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/ContactController.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure controller is registered
    if (!Get.isRegistered<ContactController>()) {
      Get.put(ContactController());
    }

    // Trigger data fetch after view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchContacts();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed('/mainpage'); // Go back to Main Page properly
          },
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // Handle loading state
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top banner section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get in Touch',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Feel free to reach out to us with any questions or feedback',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Contact Info Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildContactCard(
                              context,
                              Icons.email_outlined,
                              'Email',
                              controller.contact.value?.email ??
                                  "No email available",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildContactCard(
                              context,
                              Icons.phone_outlined,
                              'Phone',
                              controller.contact.value?.phone ??
                                  "No phone available",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Form section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send us a message',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Subject Field
                      _buildTextField(
                        controller.subject,
                        'Subject',
                        'What is your message about?',
                        Icons.subject,
                      ),
                      const SizedBox(height: 16),

                      // Message Field
                      _buildTextField(
                        controller.message,
                        'Message',
                        'Type your message here...',
                        Icons.message_outlined,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 24),

                      // Send Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.subject.text.trim().isEmpty ||
                                controller.message.text.trim().isEmpty) {
                              Get.snackbar(
                                "Form Incomplete",
                                "Please fill in all fields",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red[400],
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 8,
                                icon: const Icon(Icons.warning,
                                    color: Colors.white),
                              );
                              return;
                            }
                            controller.addMessage();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.send_rounded),
                              SizedBox(width: 8),
                              Text(
                                'Send Message',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Helper method to build contact info cards
  Widget _buildContactCard(
      BuildContext context, IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
