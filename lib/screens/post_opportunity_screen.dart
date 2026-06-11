import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/post_service.dart';
import '../services/mock_data.dart';
import '../services/auth_service.dart';

class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _organizerCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();

  String _category = 'Event';
  bool _loading = false;
  String? _error;

  final _postCategories = categories.where((c) => c != 'All').toList();

  @override
  void initState() {
    super.initState();
    _organizerCtrl.text = AuthService.currentUser?.name ?? '';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _organizerCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
    });
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final location = _locationCtrl.text.trim();
    final organizer = _organizerCtrl.text.trim();
    final date = _dateCtrl.text.trim();
    final time = _timeCtrl.text.trim();

    if (title.isEmpty || desc.isEmpty || location.isEmpty || date.isEmpty) {
      setState(() => _error = 'Please fill in all required fields');
      return;
    }

    setState(() => _loading = true);
    await PostService.submitPost(
      title: title,
      category: _category,
      description: desc,
      date: date,
      time: time,
      location: location,
      organizer: organizer,
      postedBy: AuthService.currentUser!.email,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Submitted for staff review!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (_, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dateCtrl.text = '${_month(picked.month)} ${picked.day}, ${picked.year}';
    }
  }

  String _month(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Opportunity'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submit,
            child: const Text(
              'Submit',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.gold,
                    size: 16,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your post will be reviewed by staff before going live on the feed.',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
            ],

            _label('Category *'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _postCategories.map((cat) {
                final selected = cat == _category;
                final emoji = categoryEmojis[cat] ?? '📌';
                return GestureDetector(
                  onTap: () => setState(() => _category = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.accent.withValues(alpha: 0.2)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.accent : AppColors.divider,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      '$emoji $cat',
                      style: TextStyle(
                        color: selected
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            _label('Title *'),
            const SizedBox(height: 8),
            _field(
              _titleCtrl,
              'e.g. Annual Hackathon 2025',
              Icons.title_rounded,
            ),
            const SizedBox(height: 20),

            _label('Organizer'),
            const SizedBox(height: 8),
            _field(_organizerCtrl, 'Club or team name', Icons.groups_rounded),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Date *'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: _field(
                            _dateCtrl,
                            'Pick a date',
                            Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Time'),
                      const SizedBox(height: 8),
                      _field(_timeCtrl, '10:00 AM', Icons.access_time_rounded),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _label('Location *'),
            const SizedBox(height: 8),
            _field(
              _locationCtrl,
              'e.g. Main Hall, Block B',
              Icons.location_on_outlined,
            ),
            const SizedBox(height: 20),

            _label('Description *'),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              maxLines: 5,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText:
                    'Describe the opportunity, what attendees can expect, requirements, etc.',
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _submit,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(_loading ? 'Submitting...' : 'Submit for Review'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _field(TextEditingController ctrl, String hint, IconData icon) =>
      TextField(
        controller: ctrl,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      );
}
