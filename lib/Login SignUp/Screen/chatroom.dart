import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends StatefulWidget {
  final String communityId;
  final String username;

  ChatRoomScreen(this.communityId, this.username);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.communityId)
        .collection('messages')
        .add({
      'text': message,
      'sender': widget.username,
      'timestamp': Timestamp.now(),
    });
    _messageController.clear();
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  void _showMessageOptions(DocumentSnapshot messageSnapshot) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Message'),
              onTap: () {
                Navigator.pop(ctx);
                _editMessage(messageSnapshot);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Message'),
              onTap: () {
                Navigator.pop(ctx);
                _deleteMessage(messageSnapshot);
              },
            ),
          ],
        );
      },
    );
  }

  void _editMessage(DocumentSnapshot messageSnapshot) {
    String currentMessage = messageSnapshot['text'];
    _messageController.text = currentMessage;
    // Delete original message after editing
    _deleteMessage(messageSnapshot);
  }

  void _deleteMessage(DocumentSnapshot messageSnapshot) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.communityId)
        .collection('messages')
        .doc(messageSnapshot.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chat Room')),
        backgroundColor: Color.fromARGB(255, 0, 55, 102), // Set app bar background color
        foregroundColor: Colors.white, // Set app bar text color
      ),
      backgroundColor: Color.fromARGB(255, 0, 55, 102), // Set scaffold background color
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(widget.communityId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = chatSnapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    final messageData = chatDocs[index];
                    final isCurrentUser = messageData['sender'] == widget.username;

                    return GestureDetector(
                      onLongPress: () => _showMessageOptions(messageData),
                      child: Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue : Colors.grey[700],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                child: Text(
                                  messageData['sender'][0].toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    messageData['text'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        messageData['sender'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        _formatTimestamp(messageData['timestamp']),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white), 
                    decoration: InputDecoration(
                      labelText: 'Send a message...',
                      labelStyle: TextStyle(color: Colors.white), 
                      hintText: 'Type your message here...',
                      hintStyle: TextStyle(color: Colors.white70), 
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), 
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
