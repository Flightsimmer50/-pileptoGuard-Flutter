class FeedbacksModel{
  String? feedback;

  FeedbacksModel(
      this.feedback,
      );

  FeedbacksModel.fromJson(Map<String, dynamic> json) {
    feedback = json['feedback'];

  }
}