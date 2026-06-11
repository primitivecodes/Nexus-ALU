import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/mock_data.dart';
import '../services/rsvp_service.dart';

class RsvpRegistrationScreen extends StatefulWidget {
  final OpportunityModel opportunity;
  final String userName;
  final String userEmail;
  final String userCohort;

  const RsvpRegistrationScreen({
    super.key,
    required this.opportunity,
    required this.userName,
    required this.userEmail,
    required this.userCohort,
  });

  @override
  State<RsvpRegistrationScreen> createState() => _RsvpRegistrationScreenState();
}

class _RsvpRegistrationScreenState extends State<RsvpRegistrationScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _cohortCtrl;
  String _tshirt = 'M';
  bool _shuttle = false;
  bool _loading = false;
  RsvpModel? _ticket;

  final _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.userName);
    _emailCtrl = TextEditingController(text: widget.userEmail);
    _cohortCtrl = TextEditingController(text: widget.userCohort);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _cohortCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Name and email are required'),
            backgroundColor: AppColors.danger),
      );
      return;
    }
    setState(() => _loading = true);
    final ticket = await RsvpService.register(
      opportunityId: widget.opportunity.id,
      opportunityTitle: widget.opportunity.title,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      cohort: _cohortCtrl.text.trim(),
      tshirtSize: _tshirt,
      needsShuttle: _shuttle,
    );
    if (mounted)
      setState(() {
        _ticket = ticket;
        _loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_ticket == null ? 'Register' : 'Your Ticket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context, _ticket != null),
        ),
      ),
      body: _ticket != null
          ? _TicketView(ticket: _ticket!)
          : _FormView(
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              cohortCtrl: _cohortCtrl,
              opportunity: widget.opportunity,
              tshirt: _tshirt,
              shuttle: _shuttle,
              sizes: _sizes,
              loading: _loading,
              onTshirtChanged: (v) => setState(() => _tshirt = v),
              onShuttleChanged: (v) => setState(() => _shuttle = v!),
              onSubmit: _submit,
            ),
    );
  }
}

class _FormView extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController cohortCtrl;
  final OpportunityModel opportunity;
  final String tshirt;
  final bool shuttle;
  final List<String> sizes;
  final bool loading;
  final ValueChanged<String> onTshirtChanged;
  final ValueChanged<bool?> onShuttleChanged;
  final VoidCallback onSubmit;

  const _FormView({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.cohortCtrl,
    required this.opportunity,
    required this.tshirt,
    required this.shuttle,
    required this.sizes,
    required this.loading,
    required this.onTshirtChanged,
    required this.onShuttleChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event summary pill
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Text(opportunity.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(opportunity.title,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      Text('${opportunity.date} · ${opportunity.time}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          _section('Personal Details'),
          const SizedBox(height: 12),
          _fLabel('Full Name'),
          const SizedBox(height: 6),
          _field(nameCtrl, 'Your full name', Icons.person_outline_rounded),
          const SizedBox(height: 16),
          _fLabel('Email'),
          const SizedBox(height: 6),
          _field(emailCtrl, 'your@email.com', Icons.alternate_email_rounded,
              keyboard: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _fLabel('Cohort'),
          const SizedBox(height: 6),
          _field(cohortCtrl, 'e.g. Class of 2026', Icons.school_outlined),
          const SizedBox(height: 28),

          _section('Preferences'),
          const SizedBox(height: 12),
          _fLabel('T-Shirt Size'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: sizes.map((s) {
              final selected = s == tshirt;
              return GestureDetector(
                onTap: () => onTshirtChanged(s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accent : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: selected ? AppColors.accent : AppColors.divider),
                  ),
                  child: Center(
                    child: Text(s,
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: CheckboxListTile(
              title: const Text('I need shuttle transport',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
              subtitle: const Text('We\'ll arrange campus pickup',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              value: shuttle,
              onChanged: onShuttleChanged,
              activeColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 36),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loading ? null : onSubmit,
              icon: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.confirmation_number_outlined, size: 18),
              label: Text(loading ? 'Registering...' : 'Confirm Registration'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _section(String text) => Text(text,
      style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700));
  Widget _fLabel(String text) => Text(text,
      style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600));
  Widget _field(TextEditingController ctrl, String hint, IconData icon,
          {TextInputType? keyboard}) =>
      TextField(
        controller: ctrl,
        keyboardType: keyboard,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      );
}

class _TicketView extends StatelessWidget {
  final RsvpModel ticket;
  const _TicketView({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            const Text("You're registered!",
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Show this ticket at the event entrance',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 32),

            // Ticket card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        const Text('🎟️', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ticket.opportunityTitle,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dashed separator
                  Row(
                    children: [
                      Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle)),
                      Expanded(
                        child: LayoutBuilder(builder: (_, constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (_) => const SizedBox(
                                  width: 6,
                                  height: 1,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: AppColors.divider))),
                            ),
                          );
                        }),
                      ),
                      Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _row('Name', ticket.name),
                        _row('Email', ticket.email),
                        if (ticket.cohort.isNotEmpty)
                          _row('Cohort', ticket.cohort),
                        _row('T-Shirt', ticket.tshirtSize),
                        _row('Shuttle', ticket.needsShuttle ? 'Yes' : 'No'),
                        const SizedBox(height: 20),
                        // QR code placeholder
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.qr_code_2_rounded,
                                  color: AppColors.textPrimary, size: 80),
                              const SizedBox(height: 4),
                              Text(ticket.ticketCode,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                      letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Back to Event'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text('$label:',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
