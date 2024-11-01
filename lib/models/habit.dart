class Habit {
  int? id;
  String name;
  String description;
  String startDate;
  String endDate;
  bool isCompleted;

  Habit({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });

  // Convert a Habit into a Map. The keys must correspond to the database columns.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Extract a Habit object from a Map.
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
