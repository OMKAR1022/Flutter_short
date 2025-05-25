import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Chat Clone',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingController;
  bool _showTyping = false;
  Timer? _demoTimer;
  int _currentMessageIndex = 0;

  // Demo messages for the 30-second showcase
  final List<Message> _demoMessages = [
    Message(
      text: "Hey! How are you doing? 😊",
      isMe: false,
      time: "10:30 AM",
      status: MessageStatus.read,
    ),
    Message(
      text: "I'm doing great! Thanks for asking 🙌",
      isMe: true,
      time: "10:31 AM",
      status: MessageStatus.read,
    ),
    Message(
      text: "That's awesome to hear!",
      isMe: false,
      time: "10:31 AM",
      status: MessageStatus.read,
    ),
    Message(
      text: "Want to grab coffee later? ☕",
      isMe: false,
      time: "10:32 AM",
      status: MessageStatus.read,
    ),
    Message(
      text: "What time works for you?",
      isMe: true,
      time: "10:33 AM",
      status: MessageStatus.delivered,
    ),
    Message(
      text: "How about 3 PM at the usual place?",
      isMe: false,
      time: "10:34 AM",
      status: MessageStatus.sent,
    ),
    Message(
      text: "Perfect! See you there 👍",
      isMe: true,
      time: "10:35 AM",
      status: MessageStatus.sent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Start the demo after a short delay
    Future.delayed(const Duration(milliseconds: 500), _startDemo);
  }

  void _startDemo() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (_currentMessageIndex < _demoMessages.length) {
        _addMessage(_demoMessages[_currentMessageIndex]);
        _currentMessageIndex++;
      } else {
        // Restart demo after showing all messages
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _messages.clear();
            _currentMessageIndex = 0;
          });
        });
      }
    });
  }

  void _addMessage(Message message) {
    // Show typing indicator for received messages
    if (!message.isMe) {
      setState(() {
        _showTyping = true;
      });

      // Hide typing and show message after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _showTyping = false;
          _messages.add(message);
        });
        _scrollToBottom();
      });
    } else {
      setState(() {
        _messages.add(message);
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _typingController.dispose();
    _demoTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5DDD5), // WhatsApp background
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length + (_showTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _showTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index], index);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF075E54), // WhatsApp green
      elevation: 0,
      automaticallyImplyLeading: false, // Remove default leading
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.call, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: message.isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!message.isMe) const SizedBox(width: 0),
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: message.isMe
                            ? const Color(0xFFDCF8C6) // Light green for sent
                            : Colors.white, // White for received
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                          bottomRight: Radius.circular(message.isMe ? 4 : 18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            message.text,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              if (message.isMe) ...[
                                const SizedBox(width: 4),
                                _buildMessageStatus(message.status),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (message.isMe) const SizedBox(width: 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageStatus(MessageStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.grey;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.grey;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = const Color(0xFF4FC3F7); // Blue for read
        break;
    }

    return Icon(
      icon,
      size: 16,
      color: color,
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(width: 50),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _typingController,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final animationValue = (_typingController.value + delay) % 1.0;
                    final opacity = (animationValue < 0.5)
                        ? animationValue * 2
                        : 2 - (animationValue * 2);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: Opacity(
                        opacity: opacity.clamp(0.3, 1.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFFF0F0F0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined,
                        color: Colors.grey.shade600),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey.shade600),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.grey.shade600),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF075E54),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  final String time;
  final MessageStatus status;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
    required this.status,
  });
}

enum MessageStatus {
  sent,
  delivered,
  read,
}