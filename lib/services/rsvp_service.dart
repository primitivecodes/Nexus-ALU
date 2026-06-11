import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RsvpModel {
  final String opportunityId;
  final String opportunityTitle;
  final String name;
  final String email;
  final String cohort;
  final String tshirtSize;
  final bool needsShuttle;
  final String ticketCode;
  final DateTime registeredAt;

  RsvpModel({
    required this.opportunityId,
    required this.opportunityTitle,
    required this.name,
    required this.email,
    required this.cohort,
    required this.tshirtSize,
    required this.needsShuttle,
    required this.ticketCode,
    required this.registeredAt,
  });

  Map<String, dynamic> toMap() => {
    'opportunityId': opportunityId,
    'opportunityTitle': opportunityTitle,
    'name': name,
    'email': email,
    'cohort': cohort,
    'tshirtSize': tshirtSize,
    'needsShuttle': needsShuttle,
    'ticketCode': ticketCode,
    'registeredAt': registeredAt.toIso8601String(),
  };

  factory RsvpModel.fromMap(Map<String, dynamic> m) => RsvpModel(
    opportunityId: m['opportunityId'],
    opportunityTitle: m['opportunityTitle'],
    name: m['name'],
    email: m['email'],
    cohort: m['cohort'],
    tshirtSize: m['tshirtSize'],
    needsShuttle: m['needsShuttle'],
    ticketCode: m['ticketCode'],
    registeredAt: DateTime.parse(m['registeredAt']),
  );
}

class RsvpService {
  static final List<RsvpModel> _rsvps = [];

  static List<RsvpModel> get myRsvps => List.unmodifiable(_rsvps);

  static bool hasRsvped(String opportunityId) =>
      _rsvps.any((r) => r.opportunityId == opportunityId);

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('rsvps');
    if (raw != null) {
      final List<dynamic> list = json.decode(raw);
      _rsvps.clear();
      _rsvps.addAll(list.map((m) => RsvpModel.fromMap(m)));
    }
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'rsvps',
      json.encode(_rsvps.map((r) => r.toMap()).toList()),
    );
  }

  static Future<RsvpModel> register({
    required String opportunityId,
    required String opportunityTitle,
    required String name,
    required String email,
    required String cohort,
    required String tshirtSize,
    required bool needsShuttle,
  }) async {
    final code =
        'ALU-${opportunityId.toUpperCase().replaceAll('_', '').substring(0, 4)}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final rsvp = RsvpModel(
      opportunityId: opportunityId,
      opportunityTitle: opportunityTitle,
      name: name,
      email: email,
      cohort: cohort,
      tshirtSize: tshirtSize,
      needsShuttle: needsShuttle,
      ticketCode: code,
      registeredAt: DateTime.now(),
    );
    _rsvps.add(rsvp);
    await _save();
    return rsvp;
  }

  static Future<void> cancelRsvp(String opportunityId) async {
    _rsvps.removeWhere((r) => r.opportunityId == opportunityId);
    await _save();
  }
}
