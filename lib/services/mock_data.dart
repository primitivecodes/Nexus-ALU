class OpportunityModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String time;
  final String location;
  final String organizer;
  final String status; // 'approved' | 'pending' | 'rejected'
  final String? rejectionNote;
  final String postedBy; // email
  final int attendeeCount;
  final String emoji;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.status,
    this.rejectionNote,
    required this.postedBy,
    this.attendeeCount = 0,
    this.emoji = '📌',
  });

  OpportunityModel copyWith({String? status, String? rejectionNote}) {
    return OpportunityModel(
      id: id,
      title: title,
      category: category,
      description: description,
      date: date,
      time: time,
      location: location,
      organizer: organizer,
      status: status ?? this.status,
      rejectionNote: rejectionNote ?? this.rejectionNote,
      postedBy: postedBy,
      attendeeCount: attendeeCount,
      emoji: emoji,
    );
  }
}

final List<OpportunityModel> seedOpportunities = [
  OpportunityModel(
    id: 'op1',
    title: 'ALU Innovation Hackathon 2025',
    category: 'Hackathon',
    description:
        'Join us for a 48-hour hackathon challenging you to build tech solutions for African problems. Teams of 3–5 will compete for prizes and mentorship opportunities. All skill levels welcome!',
    date: 'Jun 28, 2025',
    time: '8:00 AM',
    location: 'ALU Kigali Campus — Main Hall',
    organizer: 'ALU Tech Club',
    status: 'approved',
    postedBy: 'admin@alueducation.com',
    attendeeCount: 47,
    emoji: '💡',
  ),
  OpportunityModel(
    id: 'op2',
    title: 'Leadership Masterclass Series',
    category: 'Workshop',
    description:
        'A 4-week immersive workshop on transformational leadership, public speaking, and team management facilitated by industry leaders. Each session is 2 hours.',
    date: 'Jul 5, 2025',
    time: '2:00 PM',
    location: 'ALU Auditorium',
    organizer: 'Student Leadership Council',
    status: 'approved',
    postedBy: 'admin@alueducation.com',
    attendeeCount: 92,
    emoji: '🎤',
  ),
  OpportunityModel(
    id: 'op3',
    title: 'Google STEP Internship Info Session',
    category: 'Internship',
    description:
        'Google engineers and recruiters are coming to campus to share details about the STEP Internship program. Bring your CV and prepare questions!',
    date: 'Jul 12, 2025',
    time: '10:00 AM',
    location: 'Room 204, Block B',
    organizer: 'Career Services',
    status: 'approved',
    postedBy: 'admin@alueducation.com',
    attendeeCount: 130,
    emoji: '🚀',
  ),
  OpportunityModel(
    id: 'op4',
    title: 'Debate Club Open Recruitment',
    category: 'Club',
    description:
        'The ALU Debate Club is recruiting new members for the 2025/2026 academic year. No prior experience needed — just passion for ideas and argumentation.',
    date: 'Jun 20, 2025',
    time: '5:00 PM',
    location: 'Seminar Room 1',
    organizer: 'Debate Club',
    status: 'approved',
    postedBy: 'admin@alueducation.com',
    attendeeCount: 28,
    emoji: '🗣️',
  ),
  OpportunityModel(
    id: 'op5',
    title: 'Mental Health & Wellness Week',
    category: 'Event',
    description:
        'A week-long series of activities including yoga sessions, peer support circles, art therapy, and talks from mental health professionals. Your wellbeing matters.',
    date: 'Jul 7, 2025',
    time: '9:00 AM',
    location: 'Campus-wide',
    organizer: 'Student Wellness Office',
    status: 'approved',
    postedBy: 'admin@alueducation.com',
    attendeeCount: 215,
    emoji: '🧘',
  ),
  OpportunityModel(
    id: 'op6',
    title: 'Startup Pitch Night: Season 3',
    category: 'Startup',
    description:
        'ALU student entrepreneurs pitch their startups to investors and mentors. Audience votes for People\'s Choice. Past winners have received funding and incubation.',
    date: 'Jul 19, 2025',
    time: '6:00 PM',
    location: 'Innovation Hub',
    organizer: 'ALU Entrepreneurship Club',
    status: 'approved',
    postedBy: 'admin@alueducation.com',
    attendeeCount: 178,
    emoji: '💼',
  ),
  OpportunityModel(
    id: 'op7',
    title: 'Pan-African Cultural Night',
    category: 'Event',
    description:
        'Celebrate the diversity of ALU\'s 40+ nationalities through music, dance, food, and fashion from across the continent. An unmissable evening!',
    date: 'Aug 2, 2025',
    time: '7:00 PM',
    location: 'ALU Outdoor Pavilion',
    organizer: 'Culture Council',
    status: 'approved',
    postedBy: 'admin@alueducation.com',
    attendeeCount: 340,
    emoji: '🌍',
  ),
];

const List<String> categories = [
  'All',
  'Event',
  'Hackathon',
  'Workshop',
  'Club',
  'Internship',
  'Startup',
  'Announcement',
];

const Map<String, String> categoryEmojis = {
  'Event': '🎉',
  'Hackathon': '💡',
  'Workshop': '🔧',
  'Club': '🤝',
  'Internship': '🚀',
  'Startup': '💼',
  'Announcement': '📢',
};
