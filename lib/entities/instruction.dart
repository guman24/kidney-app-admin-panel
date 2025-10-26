// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

class Instruction extends Equatable {
  final String instruction;
  final int step;

  const Instruction({required this.instruction, required this.step});

  @override
  List<Object?> get props => [instruction, step];

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      instruction: json.getStringFromJson('instruction'),
      step: json.getIntFromJson('step'),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'instruction': instruction, 'step': step};
  }

  Instruction copyWith({String? instruction, int? step}) {
    return Instruction(
      instruction: instruction ?? this.instruction,
      step: step ?? this.step,
    );
  }
}
