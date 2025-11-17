import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

class Inspiration extends Equatable {
  final String id;
  final String quote;
  final DateTime? createdAt;

  const Inspiration({
    required this.id,
    required this.quote,
    required this.createdAt,
  });

  factory Inspiration.fromJson(Map<String, dynamic> json) {
    return Inspiration(
      id: json.getStringFromJson('id'),
      quote: json.getStringFromJson('quote'),
      createdAt: json.getDateTimeOrNull('createdAt'),
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "quote": quote, "createdAt": createdAt};
  }

  @override
  List<Object?> get props => [id];
}
