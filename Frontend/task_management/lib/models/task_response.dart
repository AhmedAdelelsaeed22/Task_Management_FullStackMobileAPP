class TaskModel {
  int taskId;
  int userId;
  int statusId;
  int priorityId;
  String title;
  String? description;
  double? estimateHours;
  String creationDate;
  String? lastUpdateDate;
  String? completionDate;

  TaskModel({
    required this.taskId,
    required this.userId,
    required this.statusId,
    required this.priorityId,
    required this.title,
    this.description,
    this.estimateHours,
    required this.creationDate,
    this.lastUpdateDate,
    this.completionDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['task_id'],
      userId: json['user_id'],
      statusId: json['status_id'],
      priorityId: json['priority_id'],
      title: json['title'],
      description: json['description'],
      estimateHours: json['estimate_hours']?.toDouble(),
      creationDate: json['creation_date'],
      lastUpdateDate: json['last_update_date'],
      completionDate: json['completion_date'],
    );
  }
}
