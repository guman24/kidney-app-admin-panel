import 'package:flutter/material.dart';
import 'package:kidney_admin/entities/instruction.dart';
import 'package:kidney_admin/views/shared/add_more_button.dart';

import 'instruction_step_input.dart';

class InstructionsSetupArea extends StatefulWidget {
  const InstructionsSetupArea({
    super.key,
    this.instructions = const [],
    this.onChangedInstructions,
  });

  final List<Instruction> instructions;
  final Function(List<Instruction>)? onChangedInstructions;

  @override
  State<InstructionsSetupArea> createState() => _InstructionsSetupAreaState();
}

class _InstructionsSetupAreaState extends State<InstructionsSetupArea> {
  final List<Instruction> _instructions = [];

  @override
  void initState() {
    super.initState();
    if (widget.instructions.isEmpty) {
      _instructions.add(Instruction(instruction: "", step: 1));
    }
  }

  void updateInstruction(Instruction instruction) {
    final int index = _instructions.indexWhere(
      (e) =>
          e.instruction == instruction.instruction &&
          e.step == instruction.step,
    );
    if (index != -1) {
      _instructions[index] = instruction;
      setState(() {});
    }
    widget.onChangedInstructions?.call(
      _instructions.where((e) => e.instruction.isNotEmpty).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Instructions", style: Theme.of(context).textTheme.titleMedium),
          ..._instructions.map((instruction) {
            return InstructionStepInput(
              instruction: instruction,
              onChangeInstruction: updateInstruction,
            );
          }),

          AddMoreButton(
            label: "Add Steps",
            onTap: () {
              setState(() {
                _instructions.add(
                  Instruction(instruction: "", step: _instructions.length + 1),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
