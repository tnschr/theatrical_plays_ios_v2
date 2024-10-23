class Movie {
  final int id;
  final String title;
  final String? ticketUrl; // Nullable
  final String producer;
  final String? mediaUrl; // Nullable
  final String? duration; // Nullable
  final String description;
  bool isSelected;

  Movie({
    required this.id,
    required this.title,
    this.ticketUrl,
    required this.producer,
    this.mediaUrl,
    this.duration,
    required this.description,
    this.isSelected = false, // Default value
  });
}
