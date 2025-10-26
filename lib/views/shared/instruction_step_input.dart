import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/instruction.dart';

class InstructionStepInput extends StatelessWidget {
  const InstructionStepInput({
    super.key,
    required this.instruction,
    required this.onChangeInstruction,
  });

  final Instruction instruction;
  final Function(Instruction) onChangeInstruction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            constraints: BoxConstraints(maxHeight: 120, minHeight: 100.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: AppColors.gradient10),
            ),
            child: Row(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        "Step ${instruction.step}",
                        // style: AppTheme.title14.copyWith(
                        //   color: AppColors.olive100,
                        // ),
                      ),
                      SizedBox(
                        height: double.infinity,
                        child: VerticalDivider(thickness: 1),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(),
                    child: TextFormField(
                      initialValue: instruction.instruction,
                      maxLines: null,
                      onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                      textAlign: TextAlign.left,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) {
                        final updatedInstruction = instruction.copyWith(
                          instruction: value,
                        );
                        onChangeInstruction(updatedInstruction);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.gradient40),
                        hintText: "Write instruction",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 12.0),
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
          color: Theme.of(context).colorScheme.onPrimary,
          child: Text("Instruction"),
        ),
      ],
    );
  }
}
