import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/mock_data.dart';
import '../services/rsvp_service.dart';
import '../services/auth_service.dart';
import 'rsvp_registration_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final OpportunityModel opportunity;

  const EventDetailsScreen({super.key, required this.opportunity});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool get _hasRsvped => RsvpService.hasRsvped(widget.opportunity.id);

  Future<void> _cancelRsvp() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel RSVP',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to cancel your registration?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cancel RSVP',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await RsvpService.cancelRsvp(widget.opportunity.id);
      if (mounted) setState(() {});
    }
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Hackathon':
        return const Color(0xFF7C3AED);
      case 'Workshop':
        return const Color(0xFF0EA5E9);
      case 'Club':
        return const Color(0xFF10B981);
      case 'Internship':
        return const Color(0xFFF5A623);
      case 'Startup':
        return const Color(0xFFEF4444);
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final op = widget.opportunity;
    final catColor = _categoryColor(op.category);
    final user = AuthService.currentUser!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      catColor.withValues(alpha: 0.8),
                      AppColors.primary,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(op.emoji, style: const TextStyle(fontSize: 80)),
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          op.category.toUpperCase(),
                          style: TextStyle(
                            color: catColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_hasRsvped)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.success,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Registered',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    op.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Organized by ${op.organizer}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info grid
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.calendar_today_rounded,
                          label: 'Date',
                          value: op.date,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.access_time_rounded,
                          label: 'Time',
                          value: op.time,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    value: op.location,
                    full: true,
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.group_rounded,
                    label: 'Attendees',
                    value:
                        '${op.attendeeCount + (_hasRsvped ? 1 : 0)} registered',
                    full: true,
                    valueColor: AppColors.accent,
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'About',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    op.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (_hasRsvped) ...[
                    OutlinedButton.icon(
                      onPressed: _cancelRsvp,
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Cancel RSVP'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final registered = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RsvpRegistrationScreen(
                                opportunity: op,
                                userName: user.name,
                                userEmail: user.email,
                                userCohort: user.cohort,
                              ),
                            ),
                          );
                          if (registered == true && mounted) setState(() {});
                        },
                        icon: const Icon(Icons.how_to_reg_rounded, size: 18),
                        label: const Text('RSVP / Register Now'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool full;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.full = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: full ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
