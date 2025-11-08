enum DifficultyLevel {
  easy,
  medium,
  hard,
}

extension DifficultyExtension on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  String get icon {
    switch (this) {
      case DifficultyLevel.easy:
        return '🟢';
      case DifficultyLevel.medium:
        return '🟡';
      case DifficultyLevel.hard:
        return '🔴';
    }
  }
}

class ExampleModel {
  final String title;
  final String expression;
  final String conversionType;
  final DifficultyLevel difficulty;
  final String description;
  final String expectedResult;

  ExampleModel({
    required this.title,
    required this.expression,
    required this.conversionType,
    required this.difficulty,
    required this.description,
    required this.expectedResult,
  });

  /// Static list of predefined examples
  static List<ExampleModel> getAllExamples() {
    return [
      // EASY EXAMPLES
      ExampleModel(
        title: 'Simple Addition',
        expression: 'A+B',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Basic addition of two operands',
        expectedResult: 'AB+',
      ),

      ExampleModel(
        title: 'Simple Multiplication',
        expression: 'A*B',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Basic multiplication operation',
        expectedResult: 'AB*',
      ),

      ExampleModel(
        title: 'Two Operations',
        expression: 'A+B-C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Two operations with same precedence',
        expectedResult: 'AB+C-',
      ),

      ExampleModel(
        title: 'Postfix to Infix Easy',
        expression: 'AB+',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.easy,
        description: 'Convert simple postfix to infix',
        expectedResult: '(A+B)',
      ),

      // MEDIUM EXAMPLES
      ExampleModel(
        title: 'Mixed Precedence',
        expression: 'A+B*C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Addition and multiplication with different precedence',
        expectedResult: 'ABC*+',
      ),

      ExampleModel(
        title: 'With Parentheses',
        expression: '(A+B)*C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Parentheses change the evaluation order',
        expectedResult: 'AB+C*',
      ),

      ExampleModel(
        title: 'Multiple Operations',
        expression: 'A*B+C*D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Multiple operations of same precedence',
        expectedResult: 'AB*CD*+',
      ),

      ExampleModel(
        title: 'Prefix Conversion',
        expression: 'A+B*C',
        conversionType: 'Infix to Prefix',
        difficulty: DifficultyLevel.medium,
        description: 'Convert to prefix notation',
        expectedResult: '+A*BC',
      ),

      ExampleModel(
        title: 'Postfix Complex',
        expression: 'ABC*+D-',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.medium,
        description: 'Multiple operations in postfix',
        expectedResult: '((A+(B*C))-D)',
      ),

      // HARD EXAMPLES
      ExampleModel(
        title: 'Nested Parentheses',
        expression: '((A+B)*C)-D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Multiple nested parentheses',
        expectedResult: 'AB+C*D-',
      ),

      ExampleModel(
        title: 'Complex Expression',
        expression: '(A+B)*(C-D)/(E+F)',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Complex expression with multiple operators',
        expectedResult: 'AB+CD-*EF+/',
      ),

      ExampleModel(
        title: 'With Exponentiation',
        expression: 'A+B*C^D-E',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Expression with power operator',
        expectedResult: 'ABCD^*+E-',
      ),

      ExampleModel(
        title: 'Complex Prefix',
        expression: '(A+B)*(C-D)',
        conversionType: 'Infix to Prefix',
        difficulty: DifficultyLevel.hard,
        description: 'Complex expression to prefix',
        expectedResult: '*+AB-CD',
      ),

      ExampleModel(
        title: 'Advanced Postfix',
        expression: 'AB+CD-*EF+/',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.hard,
        description: 'Complex postfix to infix conversion',
        expectedResult: '(((A+B)*(C-D))/(E+F))',
      ),

      ExampleModel(
        title: 'Prefix to Infix Hard',
        expression: '*+AB-CD',
        conversionType: 'Prefix to Infix',
        difficulty: DifficultyLevel.hard,
        description: 'Convert complex prefix to infix',
        expectedResult: '((A+B)*(C-D))',
      ),
    ];
  }

  /// Filter examples by difficulty
  static List<ExampleModel> getExamplesByDifficulty(DifficultyLevel difficulty) {
    return getAllExamples()
        .where((example) => example.difficulty == difficulty)
        .toList();
  }

  /// Filter examples by conversion type
  static List<ExampleModel> getExamplesByType(String type) {
    return getAllExamples()
        .where((example) => example.conversionType == type)
        .toList();
  }
}