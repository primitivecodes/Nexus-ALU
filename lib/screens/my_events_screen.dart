import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/rsvp_service.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../services/mock_data.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;
    final rsvps = RsvpService.myRsvps;
    final myPosts = PostService.postsBy(user.email);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Activity'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: AppColors.accent,
          indicatorWeight: 3,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: [
            Tab(text: 'Registered (${rsvps.length})'),
            Tab(text: 'My Posts (${myPosts.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          // Registered events
          rsvps.isEmpty
              ? _EmptyState(
                  emoji: '🎟️',
                  title: 'No registrations yet',
                  subtitle: 'RSVP to events from the Discover feed',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rsvps.length,
                  itemBuilder: (_, i) => _RsvpCard(
                    rsvp: rsvps[i],
                    onCancel: () => setState(() {}),
                  ),
                ),
          // My posts
          myPosts.isEmpty
              ? _EmptyState(
                  emoji: '📝',
                  title: 'No posts yet',
                  subtitle:
                      'Tap the + Post button on the feed to share an opportunity',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myPosts.length,
                  itemBuilder: (_, i) => _PostStatusCard(post: myPosts[i]),
                ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  const _EmptyState({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RsvpCard extends StatelessWidget {
  final RsvpModel rsvp;
  final VoidCallback onCancel;
  const _RsvpCard({required this.rsvp, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number_rounded,
                      color: AppColors.success,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rsvp.opportunityTitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _chip('T-shirt: ${rsvp.tshirtSize}'),
                    const SizedBox(width: 8),
                    if (rsvp.needsShuttle) _chip('🚌 Shuttle'),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_2_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        rsvp.ticketCode,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () async {
                      await RsvpService.cancelRsvp(rsvp.opportunityId);
                      onCancel();
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 14,
                      color: AppColors.danger,
                    ),
                    label: const Text(
                      'Cancel RSVP',
                      style: TextStyle(color: AppColors.danger, fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
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

  Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.divider),
    ),
    child: Text(
      text,
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
    ),
  );
}

class _PostStatusCard extends StatelessWidget {
  final OpportunityModel post;
  const _PostStatusCard({required this.post});

  Color _statusColor() {
    switch (post.status) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  IconData _statusIcon() {
    switch (post.status) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.category,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (post.status == 'rejected' &&
                    post.rejectionNote != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Note: ${post.rejectionNote}',
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusIcon(), color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  post.status[0].toUpperCase() + post.status.substring(1),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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
