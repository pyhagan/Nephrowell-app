import 'package:ckd_mobile/Login%20SignUp/Screen/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ckd_mobile/Login%20SignUp/Services/collections.dart';
import 'package:collection/collection.dart';

// Define your Firestore collections
final CollectionReference<Map<String, dynamic>> communitiesCollection = FirebaseFirestore.instance.collection('communities');
final CollectionReference<Map<String, dynamic>> membersCollection = FirebaseFirestore.instance.collection('members');

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Communities'),
        backgroundColor: Color.fromARGB(255, 0, 55, 102),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color.fromARGB(255, 0, 55, 102),
      body: FutureBuilder<List<Community>>(
        future: fetchCommunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No communities available.'));
          } else {
            List<Community> communities = snapshot.data!;
            return ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                Community community = communities[index];
                return ListTile(
                  leading: Icon(Icons.group, color: Colors.white),
                  title: Text(
                    community.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    community.description,
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    joinCommunityDialog(context, community.id);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createCommunityDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> joinCommunityDialog(BuildContext context, String communityId) async {
    TextEditingController userIdController = TextEditingController();

    // Fetch community details to check current members
    DocumentSnapshot<Map<String, dynamic>> communitySnapshot = await communitiesCollection.doc(communityId).get();
    List<String> currentMembers = List<String>.from((communitySnapshot.data() as Map<String, dynamic>)['members'] ?? []);

    // Function to check if user is already a member of the community
    bool isUserMember(String username, List<String> members) {
      return members.contains(username);
    }

    // Check if authenticated user's username is already a member
    String username = ''; // Replace with authenticated user's username
    bool userAlreadyMember = isUserMember(username, currentMembers);

    if (!userAlreadyMember) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Join Community'),
            content: TextField(
              controller: userIdController,
              decoration: InputDecoration(hintText: 'Enter your username'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Join'),
                onPressed: () async {
                  String userId = userIdController.text.trim();
                  if (userId.isNotEmpty) {
                    await joinCommunity(communityId, userId);
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatRoomScreen(communityId, userId)),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      // User is already a member, navigate directly to chat room
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatRoomScreen(communityId, username)),
      );
    }
  }

  Future<void> createCommunityDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Community'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Community Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                String name = nameController.text.trim();
                String description = descriptionController.text.trim();
                String username = ''; // Replace with authenticated user's username
                if (name.isNotEmpty && description.isNotEmpty) {
                  createCommunity(name, description, username);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class Community {
  final String id;
  final String name;
  final String description;
  final List<String> members;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
  });

  factory Community.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Community(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      members: List<String>.from(data['members'] ?? []),
    );
  }
}

Future<List<Community>> fetchCommunities() async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await communitiesCollection.get();
  return snapshot.docs.map((doc) => Community.fromFirestore(doc)).toList();
}

Future<void> joinCommunity(String communityId, String username) async {
  try {
    await communitiesCollection.doc(communityId).update({
      'members': FieldValue.arrayUnion([username]),
    });
    // Optionally update local state or notify user
  } catch (e) {
    print('Error joining community: $e');
    // Handle error appropriately
  }
}

Future<void> createCommunity(String name, String description, String username) async {
  try {
    DocumentReference<Map<String, dynamic>> newCommunityRef = await communitiesCollection.add({
      'name': name,
      'description': description,
      'members': [username], // Add creator as first member
    });
    await membersCollection.doc(newCommunityRef.id).set({
      'members': [username],
    });
    // Optionally navigate to new community or show success message
  } catch (e) {
    print('Error creating community: $e');
    // Handle error appropriately
  }
}

