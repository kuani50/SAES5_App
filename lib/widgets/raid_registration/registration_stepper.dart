import 'package:flutter/material.dart';

class RegistrationStepper extends StatelessWidget {
  final int currentStep;

  const RegistrationStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StepItem(number: 1, label: "Course", state: _StepState.completed),
        _StepConnector(isActive: true),
        _StepItem(
          number: 2,
          label: "Équipe",
          state: currentStep > 1
              ? _StepState.completed
              : (currentStep == 1 ? _StepState.active : _StepState.inactive),
        ),
        _StepConnector(isActive: currentStep >= 1),
        _StepItem(
          number: 3,
          label: "Coéquipiers",
          state: currentStep > 2
              ? _StepState.completed
              : (currentStep == 2 ? _StepState.active : _StepState.inactive),
        ),
        _StepConnector(isActive: currentStep >= 2),
        _StepItem(
          number: 4,
          label: "Docs",
          state: currentStep > 3
              ? _StepState.completed
              : (currentStep == 3 ? _StepState.active : _StepState.inactive),
        ),
        _StepConnector(isActive: currentStep >= 3),
        _StepItem(
          number: 5,
          label: "Validation",
          state: currentStep == 4 ? _StepState.active : _StepState.inactive,
        ),
      ],
    );
  }
}

// Helper to map logic step (1-4) to visual stepper (1-5)
// Logic Step 1 (Team) -> Visual Step 2
// Logic Step 2 (Teammates) -> Visual Step 3
// Logic Step 3 (Docs) -> Visual Step 4
// Logic Step 4 (Validation) -> Visual Step 5

enum _StepState { completed, active, inactive }

class _StepItem extends StatelessWidget {
  final int number;
  final String label;
  final _StepState state;

  const _StepItem({
    required this.number,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    Color textColor;
    Widget content;

    switch (state) {
      case _StepState.completed:
        circleColor = const Color(0xFF10B981);
        textColor = Colors.black;
        content = const Icon(Icons.check, size: 16, color: Colors.white);
        break;
      case _StepState.active:
        circleColor = Colors.orange;
        textColor = Colors.black;
        content = Text(
          "$number",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case _StepState.inactive:
        circleColor = Colors.grey.shade200;
        textColor = Colors.grey.shade400;
        content = Text(
          "$number",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(child: content),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
            fontWeight: state == _StepState.active
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isActive;

  const _StepConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.grey.shade300 : Colors.grey.shade200,
        margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      ),
    );
  }
}
