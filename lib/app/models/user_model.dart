

class UserModel {
  String? fullName;
  String? email;
  String? password;
  String? classLevel;
  String? learningObjectives;
  String? type;
  String? bestSubjects;
  var phoneNumber;
  String? academicLevel;
  int? statistic;
  int? userId;
  String? avatarUrl;
  var imageFile;
  String? authToken;
  String? firebaseToken;
  static bool? auth;


  UserModel({this.userId,this.fullName, this.learningObjectives, this.email, this.authToken,
    this.firebaseToken, this.password, this.phoneNumber, this.avatarUrl, this.academicLevel,
    this.bestSubjects,this.imageFile, this.classLevel, this.type, this.statistic,});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      classLevel: json['class_level'],
      bestSubjects: json['best_subjects'],
      learningObjectives: json['learning_objectives'],
      academicLevel: json['academic_level'],
      statistic: json['statistic'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if(fullName != null){
      data['fullName'] = fullName;
    }
    if(email != null){
      data['email'] = email;
    }
    if(phoneNumber != null){
      data['phone'] = phoneNumber;
    }
    if(bestSubjects != null){
      data['best_subjects'] = bestSubjects;
    }
    else{
      data['best_subjects'] = '';
    }
    if(password != null){
      data['password'] = password;
    }
    if(authToken != null){
      data['token'] = authToken;
    }
    if(userId != null){
      data['id'] = userId;
    }

    if(learningObjectives != null){
      data['learning_objectives'] = learningObjectives;
    }
    else{
      data['learning_objectives'] = "";
    }
    if(firebaseToken != null){
      data['fcm_token'] = firebaseToken;
    }
    if(classLevel != null){
      data['class_level'] = classLevel;
    }
    if(academicLevel != null){
      data['academic_level'] = academicLevel;
    }
    if(statistic != null){
      data['statistic'] = statistic;
    }
    else{
      data['statistic'] = 0;
    }




    return data;
  }




}
