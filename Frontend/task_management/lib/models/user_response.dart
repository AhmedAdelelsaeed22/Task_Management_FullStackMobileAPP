class UserModel {
  int userId;
  String fullName;
  String userName;
  String emailAddress;
  String password;
  String? jobTitle;
  String? timeZone;
  String accountStatus;
  String? dateCreated;
  String lastLoginDate;
  String role;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.emailAddress,
    required this.password,
    this.jobTitle,
    this.timeZone,
    required this.accountStatus,
    this.dateCreated,
    required this.lastLoginDate,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      fullName: json['full_name'],
      userName: json['user_name'],
      emailAddress: json['email_address'],
      password: json['password'],
      jobTitle: json['job_title'],
      timeZone: json['time_zone'],
      accountStatus: json['account_status'],
      dateCreated: json['date_created'],
      lastLoginDate: json['last_login_date'],
      role: json['user_role'],
    );
  }
}
