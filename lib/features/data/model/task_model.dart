class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String createdDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdDate,
  });

  /// For SQLite or local Map source
  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id']?.toString() ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    status: map['status'] ?? '',
    priority: map['priority'] ?? '',
    createdDate: map['createdDate'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'createdDate': createdDate,
  };

  /// For API JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id']?.toString() ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    status: json['status'] ?? '',
    priority: json['priority'] ?? '',
    createdDate: json['createdDate'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'createdDate': createdDate,
  };
}
