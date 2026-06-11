import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'chat_list_screen.dart';

class ChatMessage {
  final String id;
  final String sender;
  final String avatar;
  final String text;
  final DateTime time;
  final Map<String, int> reactions;
  final bool isMe;
  String? replyTo;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.avatar,
    required this.text,
    required this.time,
    required this.isMe,
    this.replyTo,
    Map<String, int>? reactions,
  }) : reactions = reactions ?? {};
}

class ChatScreen extends StatefulWidget {
  final ChatRoom room;
  const ChatScreen({super.key, required this.room});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  ChatMessage? _replyingTo;
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _seedMessages();
  }

  List<ChatMessage> _seedMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: '1',
        sender: 'Amara D.',
        avatar: 'AD',
        text: 'Hey everyone! Excited to be here 🎉',
        time: now.subtract(const Duration(hours: 3)),
        isMe: false,
        reactions: {'❤️': 4, '🔥': 2},
      ),
      ChatMessage(
        id: '2',
        sender: 'Kofi M.',
        avatar: 'KM',
        text:
            'Welcome! This platform is amazing. Who else is signing up for the hackathon?',
        time: now.subtract(const Duration(hours: 2, minutes: 30)),
        isMe: false,
      ),
      ChatMessage(
        id: '3',
        sender: 'You',
        avatar: AuthService.currentUser?.avatar ?? '?',
        text: 'Definitely signing up! Already formed a team of 4.',
        time: now.subtract(const Duration(hours: 2)),
        isMe: true,
        reactions: {'👍': 3},
      ),
      ChatMessage(
        id: '4',
        sender: 'Fatima A.',
        avatar: 'FA',
        text: 'Can someone share the registration link again?',
        time: now.subtract(const Duration(hours: 1, minutes: 45)),
        isMe: false,
      ),
      ChatMessage(
        id: '5',
        sender: 'Amara D.',
        avatar: 'AD',
        text:
            'Check the Discover feed — it\'s right there under Hackathon category!',
        time: now.subtract(const Duration(hours: 1, minutes: 30)),
        isMe: false,
        replyTo: 'Can someone share the registration link again?',
      ),
    ];
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: 'You',
          avatar: AuthService.currentUser?.avatar ?? '?',
          text: text,
          time: DateTime.now(),
          isMe: true,
          replyTo: _replyingTo?.text,
        ),
      );
      _replyingTo = null;
      _msgCtrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _react(ChatMessage msg, String emoji) {
    setState(() {
      msg.reactions[emoji] = (msg.reactions[emoji] ?? 0) + 1;
    });
  }

  void _showReactions(ChatMessage msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Reaction',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['❤️', '🔥', '👍', '😂', '🎉', '🙌']
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        _react(msg, e);
                        Navigator.pop(context);
                      },
                      child: Text(e, style: const TextStyle(fontSize: 30)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: widget.room.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  widget.room.emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.room.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Community room',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                return _MessageBubble(
                  message: msg,
                  onReact: () => _showReactions(msg),
                  onReply: () => setState(() => _replyingTo = msg),
                );
              },
            ),
          ),

          // Reply preview
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.surface,
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 36,
                    color: AppColors.accent,
                    margin: const EdgeInsets.only(right: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Replying to',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _replyingTo!.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _replyingTo = null),
                  ),
                ],
              ),
            ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Message ${widget.room.name}...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onReact;
  final VoidCallback onReply;

  const _MessageBubble({
    required this.message,
    required this.onReact,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onReact,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            message.avatar,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        message.sender,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              if (message.replyTo != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(10),
                    border: const Border(
                      left: BorderSide(color: AppColors.accent, width: 3),
                    ),
                  ),
                  child: Text(
                    message.replyTo!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.accent : AppColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.reactions.isNotEmpty)
                    ...message.reactions.entries.map(
                      (e) => Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Text(
                          '${e.key} ${e.value}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: onReply,
                    child: const Text(
                      'Reply',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${message.time.hour > 12 ? message.time.hour - 12 : message.time.hour}:${message.time.minute.toString().padLeft(2, '0')} ${message.time.hour >= 12 ? 'PM' : 'AM'}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
