import 'package:flutter/material.dart';
import '../theme.dart';
import 'chat_screen.dart';

class ChatRoom {
  final String id;
  final String name;
  final String emoji;
  final String lastMessage;
  final String time;
  final int unread;
  final Color color;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.emoji,
    required this.lastMessage,
    required this.time,
    required this.color,
    this.unread = 0,
  });
}

const _rooms = [
  ChatRoom(
    id: 'general',
    name: 'General',
    emoji: '💬',
    lastMessage: 'Welcome to NexusALU! Say hi 👋',
    time: '9:00 AM',
    color: Color(0xFF7C3AED),
    unread: 3,
  ),
  ChatRoom(
    id: 'hackathon',
    name: 'Hackathon Hub',
    emoji: '💡',
    lastMessage: 'Team formation starts next week!',
    time: '8:45 AM',
    color: Color(0xFFE94560),
    unread: 1,
  ),
  ChatRoom(
    id: 'internships',
    name: 'Careers & Internships',
    emoji: '🚀',
    lastMessage: 'Anyone going to the Google session?',
    time: 'Yesterday',
    color: Color(0xFFF5A623),
  ),
  ChatRoom(
    id: 'startups',
    name: 'Startup Corner',
    emoji: '💼',
    lastMessage: 'Looking for a CTO co-founder!',
    time: 'Yesterday',
    color: Color(0xFF10B981),
  ),
  ChatRoom(
    id: 'wellness',
    name: 'Wellness Circle',
    emoji: '🧘',
    lastMessage: 'Yoga session at 6pm today',
    time: 'Tue',
    color: Color(0xFF0EA5E9),
  ),
  ChatRoom(
    id: 'culture',
    name: 'Cultural Exchange',
    emoji: '🌍',
    lastMessage: 'Cultural Night tickets are now available',
    time: 'Mon',
    color: Color(0xFF8B5CF6),
  ),
  ChatRoom(
    id: 'alumni',
    name: 'Alumni Network',
    emoji: '🎓',
    lastMessage: 'Exciting mentorship opportunities!',
    time: 'Sun',
    color: Color(0xFF06B6D4),
  ),
];

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String _search = '';
  final _searchCtrl = TextEditingController();

  List<ChatRoom> get _filtered => _rooms
      .where((r) => r.name.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Community'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search rooms...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (_, i) {
                final room = filtered[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 0,
                  ),
                  leading: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: room.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        room.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  title: Text(
                    room.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    room.lastMessage,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        room.time,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (room.unread > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${room.unread}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen(room: room)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
