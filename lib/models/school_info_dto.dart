class SchoolInfoDto {
  final String id;
  final String schoolName;
  final int grade;
  final int classNumber;

  SchoolInfoDto({
    required this.id,
    required this.schoolName,
    required this.grade,
    required this.classNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_name': schoolName,
      'grade': grade,
      'class': classNumber,
    };
  }
}
