class ConversionStep {
  final String currentToken;
  final List<String> stack;
  final String output;
  final String description;
  final StepAction action;
  final String? poppedValue;
  final String? pushedValue;
  final int tokenIndex;

  ConversionStep({
    required this.currentToken,
    required this.stack,
    required this.output,
    required this.description,
    required this.action,
    this.poppedValue,
    this.pushedValue,
    this.tokenIndex = -1,
  });

  ConversionStep copyWith({
    String? currentToken,
    List<String>? stack,
    String? output,
    String? description,
    StepAction? action,
    String? poppedValue,
    String? pushedValue,
    int? tokenIndex,
  }) {
    return ConversionStep(
      currentToken: currentToken ?? this.currentToken,
      stack: stack ?? List.from(this.stack),
      output: output ?? this.output,
      description: description ?? this.description,
      action: action ?? this.action,
      poppedValue: poppedValue ?? this.poppedValue,
      pushedValue: pushedValue ?? this.pushedValue,
      tokenIndex: tokenIndex ?? this.tokenIndex,
    );
  }
}

enum StepAction {
  start,
  pushOperand,
  pushOperator,
  popOperator,
  pushParenthesis,
  popParenthesis,
  combine,
  complete,
}

extension StepActionExtension on StepAction {
  String get displayName {
    switch (this) {
      case StepAction.start:
        return 'Start';
      case StepAction.pushOperand:
        return 'Push Operand';
      case StepAction.pushOperator:
        return 'Push Operator';
      case StepAction.popOperator:
        return 'Pop Operator';
      case StepAction.pushParenthesis:
        return 'Push Parenthesis';
      case StepAction.popParenthesis:
        return 'Pop Parenthesis';
      case StepAction.combine:
        return 'Combine';
      case StepAction.complete:
        return 'Complete';
    }
  }

  String get icon {
    switch (this) {
      case StepAction.start:
        return '🚀';
      case StepAction.pushOperand:
        return '📥';
      case StepAction.pushOperator:
        return '➕';
      case StepAction.popOperator:
        return '📤';
      case StepAction.pushParenthesis:
        return '(';
      case StepAction.popParenthesis:
        return ')';
      case StepAction.combine:
        return '🔗';
      case StepAction.complete:
        return '✅';
    }
  }
}