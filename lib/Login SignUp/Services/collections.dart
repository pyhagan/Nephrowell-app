import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference<Map<String, dynamic>> communitiesCollection =
    FirebaseFirestore.instance.collection('communities');

/*final CollectionReference<Map<String, dynamic>> membersCollection =
    FirebaseFirestore.instance.collection('communityMembers');*/
