class LessonModel {
  final String id;
  final String title;
  final String content;
  final List<TestQuestionModel> testQuestions;

  LessonModel({
    required this.id,
    required this.title,
    required this.content,
    required this.testQuestions,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'testQuestions': testQuestions.map((q) => q.toJson()).toList(),
      };

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        testQuestions: (json['testQuestions'] as List)
            .map((q) => TestQuestionModel.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}

class TestQuestionModel {
  final String question;
  final List<String> options;
  final int correctIndex;

  TestQuestionModel({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
      };

  factory TestQuestionModel.fromJson(Map<String, dynamic> json) =>
      TestQuestionModel(
        question: json['question'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correctIndex'] as int,
      );
}

class CourseModel {
  final String id;
  final String title;
  final String description;
  final int creditCost;
  final List<LessonModel> lessons;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.creditCost,
    required this.lessons,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'creditCost': creditCost,
        'lessons': lessons.map((l) => l.toJson()).toList(),
      };

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        creditCost: json['creditCost'] as int,
        lessons: (json['lessons'] as List)
            .map((l) => LessonModel.fromJson(l as Map<String, dynamic>))
            .toList(),
      );
}
