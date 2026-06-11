import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'mock_data.dart';

class PostService {
  static final List<OpportunityModel> _posts = List.from(seedOpportunities);

  static List<OpportunityModel> get approvedPosts =>
      _posts.where((p) => p.status == 'approved').toList();

  static List<OpportunityModel> get pendingPosts =>
      _posts.where((p) => p.status == 'pending').toList();

  static List<OpportunityModel> postsBy(String email) =>
      _posts.where((p) => p.postedBy == email).toList();

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user_posts');
    if (raw != null) {
      final List<dynamic> list = json.decode(raw);
      final userPosts = list.map(
        (m) => OpportunityModel(
          id: m['id'],
          title: m['title'],
          category: m['category'],
          description: m['description'],
          date: m['date'],
          time: m['time'],
          location: m['location'],
          organizer: m['organizer'],
          status: m['status'],
          rejectionNote: m['rejectionNote'],
          postedBy: m['postedBy'],
          attendeeCount: m['attendeeCount'] ?? 0,
          emoji: m['emoji'] ?? '📌',
        ),
      );
      _posts.removeWhere((p) => !seedOpportunities.any((s) => s.id == p.id));
      _posts.addAll(userPosts);
    }
  }

  static Future<void> _saveUserPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final userPosts = _posts
        .where((p) => !seedOpportunities.any((s) => s.id == p.id))
        .toList();
    final encoded = json.encode(
      userPosts
          .map(
            (p) => {
              'id': p.id,
              'title': p.title,
              'category': p.category,
              'description': p.description,
              'date': p.date,
              'time': p.time,
              'location': p.location,
              'organizer': p.organizer,
              'status': p.status,
              'rejectionNote': p.rejectionNote,
              'postedBy': p.postedBy,
              'attendeeCount': p.attendeeCount,
              'emoji': p.emoji,
            },
          )
          .toList(),
    );
    await prefs.setString('user_posts', encoded);
  }

  static Future<void> submitPost({
    required String title,
    required String category,
    required String description,
    required String date,
    required String time,
    required String location,
    required String organizer,
    required String postedBy,
  }) async {
    final emoji = categoryEmojis[category] ?? '📌';
    final post = OpportunityModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      description: description,
      date: date,
      time: time,
      location: location,
      organizer: organizer,
      status: 'pending',
      postedBy: postedBy,
      emoji: emoji,
    );
    _posts.add(post);
    await _saveUserPosts();
  }

  static Future<void> approvePost(String id) async {
    final idx = _posts.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      _posts[idx] = _posts[idx].copyWith(status: 'approved');
      await _saveUserPosts();
    }
  }

  static Future<void> rejectPost(String id, {String? note}) async {
    final idx = _posts.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      _posts[idx] = _posts[idx].copyWith(
        status: 'rejected',
        rejectionNote: note,
      );
      await _saveUserPosts();
    }
  }
}
