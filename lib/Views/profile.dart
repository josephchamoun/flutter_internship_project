import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Update Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Update Profile",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent)),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Name", border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Email", border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Save"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Password Update Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Update Password",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent)),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Current Password",
                            border: OutlineInputBorder()),
                        obscureText: true,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "New Password",
                            border: OutlineInputBorder()),
                        obscureText: true,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Confirm New Password",
                            border: OutlineInputBorder()),
                        obscureText: true,
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Save"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Delete Account Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Delete Account",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      SizedBox(height: 12),
                      Text(
                          "Warning: This action is permanent and cannot be undone.",
                          style: TextStyle(color: Colors.redAccent)),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Delete Account"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
