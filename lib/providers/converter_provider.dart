import 'package:flutter/material.dart';
import '../models/conversion_step.dart';

class ConverterProvider extends ChangeNotifier {
  List<ConversionStep> _steps = [];
  String _result = '';
  String _inputExpression = '';
  bool _isAnimating = false;
  int _currentStepIndex = 0;

  List<ConversionStep> get steps => _steps;
  String get result => _result;
  String get inputExpression => _inputExpression;
  bool get isAnimating => _isAnimating;
  int get currentStepIndex => _currentStepIndex;

  void setCurrentStepIndex(int index) {
    _currentStepIndex = index;
    notifyListeners();
  }

  void startAnimation() {
    _isAnimating = true;
    _currentStepIndex = 0;
    notifyListeners();
  }

  void stopAnimation() {
    _isAnimating = false;
    notifyListeners();
  }

  bool _isOperator(String ch) {
    return ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '^';
  }

  int _precedence(String op) {
    switch (op) {
      case '+':
      case '-':
        return 1;
      case '*':
      case '/':
        return 2;
      case '^':
        return 3;
      default:
        return 0;
    }
  }

  bool _isOperand(String ch) {
    return RegExp(r'^[a-zA-Z0-9]$').hasMatch(ch);
  }

  String _getPrecedenceDescription(String op) {
    int prec = _precedence(op);
    switch (prec) {
      case 1:
        return 'Low precedence (+ -)';
      case 2:
        return 'Medium precedence (* /)';
      case 3:
        return 'High precedence (^)';
      default:
        return 'No precedence';
    }
  }

  void infixToPostfix(String infix) {
    _steps = [];
    _inputExpression = infix;
    _currentStepIndex = 0;
    List<String> stack = [];
    String output = '';
    int tokenIndex = 0;

    _steps.add(ConversionStep(
      currentToken: 'Initialize',
      stack: [],
      output: '',
      description: 'Starting Infix to Postfix conversion\nInput: $infix',
      action: StepAction.start,
      tokenIndex: -1,
    ));

    for (int i = 0; i < infix.length; i++) {
      String ch = infix[i];
      if (ch == ' ') continue;

      tokenIndex++;

      if (_isOperand(ch)) {
        output += ch;
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: output,
          description: 'Operand "$ch" found\n→ Add directly to output',
          action: StepAction.pushOperand,
          pushedValue: ch,
          tokenIndex: i,
        ));
      } else if (ch == '(') {
        stack.add(ch);
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: output,
          description: 'Left parenthesis "("\n→ Push to stack (marks start of sub-expression)',
          action: StepAction.pushParenthesis,
          pushedValue: ch,
          tokenIndex: i,
        ));
      } else if (ch == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          String popped = stack.removeLast();
          output += popped;
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: output,
            description: 'Right parenthesis ")"\n→ Pop "$popped" from stack to output\n→ Continue until "(" found',
            action: StepAction.popOperator,
            poppedValue: popped,
            tokenIndex: i,
          ));
        }
        if (stack.isNotEmpty) {
          stack.removeLast();
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: output,
            description: 'Matching "(" found and removed\n→ Sub-expression complete',
            action: StepAction.popParenthesis,
            poppedValue: '(',
            tokenIndex: i,
          ));
        }
      } else if (_isOperator(ch)) {
        String currentPrecedence = _getPrecedenceDescription(ch);

        while (stack.isNotEmpty &&
            stack.last != '(' &&
            _precedence(stack.last) >= _precedence(ch)) {
          String popped = stack.removeLast();
          output += popped;
          String poppedPrecedence = _getPrecedenceDescription(popped);
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: output,
            description: 'Operator "$ch" ($currentPrecedence)\n→ Pop "$popped" ($poppedPrecedence)\n→ Higher or equal precedence',
            action: StepAction.popOperator,
            poppedValue: popped,
            tokenIndex: i,
          ));
        }

        stack.add(ch);
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: output,
          description: 'Operator "$ch" ($currentPrecedence)\n→ Push to stack\n→ Wait for operands',
          action: StepAction.pushOperator,
          pushedValue: ch,
          tokenIndex: i,
        ));
      }
    }

    while (stack.isNotEmpty) {
      String popped = stack.removeLast();
      output += popped;
      _steps.add(ConversionStep(
        currentToken: 'Finalize',
        stack: List.from(stack),
        output: output,
        description: 'No more input tokens\n→ Pop remaining "$popped" to output',
        action: StepAction.popOperator,
        poppedValue: popped,
        tokenIndex: infix.length,
      ));
    }

    _result = output;
    _steps.add(ConversionStep(
      currentToken: 'Done',
      stack: [],
      output: output,
      description: 'Conversion Complete! ✨\nPostfix Result: $output',
      action: StepAction.complete,
      tokenIndex: infix.length,
    ));

    notifyListeners();
  }

  void infixToPrefix(String infix) {
    _steps = [];
    _inputExpression = infix;
    _currentStepIndex = 0;

    String reversedInfix = infix.split('').reversed.join();
    reversedInfix = reversedInfix
        .replaceAll('(', 'temp')
        .replaceAll(')', '(')
        .replaceAll('temp', ')');

    List<String> stack = [];
    String output = '';

    _steps.add(ConversionStep(
      currentToken: 'Initialize',
      stack: [],
      output: '',
      description: 'Starting Infix to Prefix conversion\nStep 1: Reverse input and swap parentheses\nReversed: $reversedInfix',
      action: StepAction.start,
      tokenIndex: -1,
    ));

    for (int i = 0; i < reversedInfix.length; i++) {
      String ch = reversedInfix[i];
      if (ch == ' ') continue;

      if (_isOperand(ch)) {
        output += ch;
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: output,
          description: 'Operand "$ch" found\n→ Add to output',
          action: StepAction.pushOperand,
          pushedValue: ch,
          tokenIndex: i,
        ));
      } else if (ch == '(') {
        stack.add(ch);
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: output,
          description: 'Left parenthesis "("\n→ Push to stack',
          action: StepAction.pushParenthesis,
          pushedValue: ch,
          tokenIndex: i,
        ));
      } else if (ch == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          String popped = stack.removeLast();
          output += popped;
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: output,
            description: 'Right parenthesis ")"\n→ Pop "$popped" to output',
            action: StepAction.popOperator,
            poppedValue: popped,
            tokenIndex: i,
          ));
        }
        if (stack.isNotEmpty) {
          stack.removeLast();
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: output,
            description: 'Matching "(" removed from stack',
            action: StepAction.popParenthesis,
            poppedValue: '(',
            tokenIndex: i,
          ));
        }
      } else if (_isOperator(ch)) {
        String currentPrecedence = _getPrecedenceDescription(ch);

        while (stack.isNotEmpty &&
            stack.last != '(' &&
            _precedence(stack.last) > _precedence(ch)) {
          String popped = stack.removeLast();
          output += popped;
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: output,
            description: 'Operator "$ch" ($currentPrecedence)\n→ Pop "$popped" (higher precedence)',
            action: StepAction.popOperator,
            poppedValue: popped,
            tokenIndex: i,
          ));
        }

        stack.add(ch);
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: output,
          description: 'Operator "$ch" ($currentPrecedence)\n→ Push to stack',
          action: StepAction.pushOperator,
          pushedValue: ch,
          tokenIndex: i,
        ));
      }
    }

    while (stack.isNotEmpty) {
      String popped = stack.removeLast();
      output += popped;
      _steps.add(ConversionStep(
        currentToken: 'Finalize',
        stack: List.from(stack),
        output: output,
        description: 'Pop remaining "$popped" to output',
        action: StepAction.popOperator,
        poppedValue: popped,
        tokenIndex: reversedInfix.length,
      ));
    }

    _result = output.split('').reversed.join();
    _steps.add(ConversionStep(
      currentToken: 'Done',
      stack: [],
      output: _result,
      description: 'Step 2: Reverse output to get Prefix\nPrefix Result: $_result',
      action: StepAction.complete,
      tokenIndex: reversedInfix.length,
    ));

    notifyListeners();
  }

  void postfixToInfix(String postfix) {
    _steps = [];
    _inputExpression = postfix;
    _currentStepIndex = 0;
    List<String> stack = [];

    _steps.add(ConversionStep(
      currentToken: 'Initialize',
      stack: [],
      output: '',
      description: 'Starting Postfix to Infix conversion\nInput: $postfix\nRule: Operand → Push, Operator → Pop 2, Combine, Push',
      action: StepAction.start,
      tokenIndex: -1,
    ));

    for (int i = 0; i < postfix.length; i++) {
      String ch = postfix[i];
      if (ch == ' ') continue;

      if (_isOperand(ch)) {
        stack.add(ch);
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: stack.isNotEmpty ? stack.last : '',
          description: 'Operand "$ch"\n→ Push to stack',
          action: StepAction.pushOperand,
          pushedValue: ch,
          tokenIndex: i,
        ));
      } else if (_isOperator(ch)) {
        if (stack.length >= 2) {
          String op2 = stack.removeLast();
          String op1 = stack.removeLast();
          String temp = '($op1$ch$op2)';
          stack.add(temp);
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: temp,
            description: 'Operator "$ch"\n→ Pop: $op2 (right operand)\n→ Pop: $op1 (left operand)\n→ Combine: ($op1 $ch $op2)\n→ Push result to stack',
            action: StepAction.combine,
            poppedValue: '$op1, $op2',
            pushedValue: temp,
            tokenIndex: i,
          ));
        }
      }
    }

    _result = stack.isNotEmpty ? stack.last : '';
    _steps.add(ConversionStep(
      currentToken: 'Done',
      stack: List.from(stack),
      output: _result,
      description: 'Conversion Complete! ✨\nInfix Result: $_result',
      action: StepAction.complete,
      tokenIndex: postfix.length,
    ));

    notifyListeners();
  }

  void prefixToInfix(String prefix) {
    _steps = [];
    _inputExpression = prefix;
    _currentStepIndex = 0;
    List<String> stack = [];

    _steps.add(ConversionStep(
      currentToken: 'Initialize',
      stack: [],
      output: '',
      description: 'Starting Prefix to Infix conversion\nInput: $prefix\nRule: Read from RIGHT to LEFT\nOperand → Push, Operator → Pop 2, Combine, Push',
      action: StepAction.start,
      tokenIndex: -1,
    ));

    for (int i = prefix.length - 1; i >= 0; i--) {
      String ch = prefix[i];
      if (ch == ' ') continue;

      if (_isOperand(ch)) {
        stack.add(ch);
        _steps.add(ConversionStep(
          currentToken: ch,
          stack: List.from(stack),
          output: stack.isNotEmpty ? stack.last : '',
          description: 'Operand "$ch" (reading from right)\n→ Push to stack',
          action: StepAction.pushOperand,
          pushedValue: ch,
          tokenIndex: i,
        ));
      } else if (_isOperator(ch)) {
        if (stack.length >= 2) {
          String op1 = stack.removeLast();
          String op2 = stack.removeLast();
          String temp = '($op1$ch$op2)';
          stack.add(temp);
          _steps.add(ConversionStep(
            currentToken: ch,
            stack: List.from(stack),
            output: temp,
            description: 'Operator "$ch" (reading from right)\n→ Pop: $op1 (left operand)\n→ Pop: $op2 (right operand)\n→ Combine: ($op1 $ch $op2)\n→ Push result to stack',
            action: StepAction.combine,
            poppedValue: '$op1, $op2',
            pushedValue: temp,
            tokenIndex: i,
          ));
        }
      }
    }

    _result = stack.isNotEmpty ? stack.last : '';
    _steps.add(ConversionStep(
      currentToken: 'Done',
      stack: List.from(stack),
      output: _result,
      description: 'Conversion Complete! ✨\nInfix Result: $_result',
      action: StepAction.complete,
      tokenIndex: 0,
    ));

    notifyListeners();
  }

  void clearResults() {
    _steps = [];
    _result = '';
    _inputExpression = '';
    _currentStepIndex = 0;
    _isAnimating = false;
    notifyListeners();
  }
}