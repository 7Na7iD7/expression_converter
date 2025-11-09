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
  final String? hint;
  final List<String>? tags;

  ExampleModel({
    required this.title,
    required this.expression,
    required this.conversionType,
    required this.difficulty,
    required this.description,
    required this.expectedResult,
    this.hint,
    this.tags,
  });

  static List<ExampleModel> getAllExamples() {
    return [

      ExampleModel(
        title: 'Simple Addition',
        expression: 'A+B',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Basic addition of two operands',
        expectedResult: 'AB+',
        hint: 'Operands first, then operator',
        tags: ['addition', 'basic'],
      ),
      ExampleModel(
        title: 'Simple Multiplication',
        expression: 'A*B',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Basic multiplication operation',
        expectedResult: 'AB*',
        tags: ['multiplication', 'basic'],
      ),
      ExampleModel(
        title: 'Simple Subtraction',
        expression: 'A-B',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Basic subtraction operation',
        expectedResult: 'AB-',
        tags: ['subtraction', 'basic'],
      ),
      ExampleModel(
        title: 'Simple Division',
        expression: 'A/B',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Basic division operation',
        expectedResult: 'AB/',
        tags: ['division', 'basic'],
      ),
      ExampleModel(
        title: 'Two Operations',
        expression: 'A+B-C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Two operations with same precedence',
        expectedResult: 'AB+C-',
        hint: 'Process left to right',
        tags: ['multiple', 'same-precedence'],
      ),
      ExampleModel(
        title: 'Three Additions',
        expression: 'A+B+C+D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Multiple additions in sequence',
        expectedResult: 'AB+C+D+',
        tags: ['addition', 'chain'],
      ),
      ExampleModel(
        title: 'Postfix Simple',
        expression: 'AB+',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.easy,
        description: 'Convert simple postfix to infix',
        expectedResult: '(A+B)',
        tags: ['postfix', 'basic'],
      ),
      ExampleModel(
        title: 'Postfix Multiplication',
        expression: 'AB*',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.easy,
        description: 'Simple postfix multiplication',
        expectedResult: '(A*B)',
        tags: ['postfix', 'multiplication'],
      ),
      ExampleModel(
        title: 'Prefix Simple',
        expression: '+AB',
        conversionType: 'Prefix to Infix',
        difficulty: DifficultyLevel.easy,
        description: 'Convert simple prefix to infix',
        expectedResult: '(A+B)',
        tags: ['prefix', 'basic'],
      ),
      ExampleModel(
        title: 'Prefix Subtraction',
        expression: '-AB',
        conversionType: 'Prefix to Infix',
        difficulty: DifficultyLevel.easy,
        description: 'Simple prefix subtraction',
        expectedResult: '(A-B)',
        tags: ['prefix', 'subtraction'],
      ),
      ExampleModel(
        title: 'Simple Prefix Conv',
        expression: 'A+B',
        conversionType: 'Infix to Prefix',
        difficulty: DifficultyLevel.easy,
        description: 'Basic infix to prefix conversion',
        expectedResult: '+AB',
        tags: ['prefix', 'basic'],
      ),
      ExampleModel(
        title: 'Chain Subtraction',
        expression: 'A-B-C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.easy,
        description: 'Multiple subtractions in sequence',
        expectedResult: 'AB-C-',
        tags: ['subtraction', 'chain'],
      ),

      ExampleModel(
        title: 'Mixed Precedence',
        expression: 'A+B*C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Addition and multiplication with different precedence',
        expectedResult: 'ABC*+',
        hint: 'Multiplication has higher precedence',
        tags: ['precedence', 'mixed'],
      ),
      ExampleModel(
        title: 'With Parentheses',
        expression: '(A+B)*C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Parentheses change the evaluation order',
        expectedResult: 'AB+C*',
        hint: 'Parentheses have highest priority',
        tags: ['parentheses', 'precedence'],
      ),
      ExampleModel(
        title: 'Multiple Operations',
        expression: 'A*B+C*D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Multiple operations of same precedence',
        expectedResult: 'AB*CD*+',
        tags: ['multiplication', 'addition'],
      ),
      ExampleModel(
        title: 'Division and Addition',
        expression: 'A/B+C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Mix of division and addition',
        expectedResult: 'AB/C+',
        tags: ['division', 'addition'],
      ),
      ExampleModel(
        title: 'Subtraction Priority',
        expression: '(A-B)+C*D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Parentheses with multiplication',
        expectedResult: 'AB-CD*+',
        tags: ['parentheses', 'mixed'],
      ),
      ExampleModel(
        title: 'Four Operations',
        expression: 'A+B-C*D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Multiple operations with different precedence',
        expectedResult: 'AB+CD*-',
        tags: ['mixed', 'precedence'],
      ),
      ExampleModel(
        title: 'Division Chain',
        expression: 'A/B/C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Multiple divisions in sequence',
        expectedResult: 'AB/C/',
        tags: ['division', 'chain'],
      ),
      ExampleModel(
        title: 'Prefix Conversion',
        expression: 'A+B*C',
        conversionType: 'Infix to Prefix',
        difficulty: DifficultyLevel.medium,
        description: 'Convert to prefix notation',
        expectedResult: '+A*BC',
        tags: ['prefix', 'precedence'],
      ),
      ExampleModel(
        title: 'Prefix with Parens',
        expression: '(A+B)*C',
        conversionType: 'Infix to Prefix',
        difficulty: DifficultyLevel.medium,
        description: 'Prefix with parentheses',
        expectedResult: '*+ABC',
        tags: ['prefix', 'parentheses'],
      ),
      ExampleModel(
        title: 'Postfix Complex',
        expression: 'ABC*+D-',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.medium,
        description: 'Multiple operations in postfix',
        expectedResult: '((A+(B*C))-D)',
        tags: ['postfix', 'complex'],
      ),
      ExampleModel(
        title: 'Postfix Four Ops',
        expression: 'AB+CD-*',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.medium,
        description: 'Four operations in postfix',
        expectedResult: '((A+B)*(C-D))',
        tags: ['postfix', 'multiple'],
      ),
      ExampleModel(
        title: 'Prefix Three Ops',
        expression: '+A*BC',
        conversionType: 'Prefix to Infix',
        difficulty: DifficultyLevel.medium,
        description: 'Three operations in prefix',
        expectedResult: '(A+(B*C))',
        tags: ['prefix', 'multiple'],
      ),
      ExampleModel(
        title: 'Mixed Operators',
        expression: 'A*B-C/D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Multiple high precedence operators',
        expectedResult: 'AB*CD/-',
        tags: ['mixed', 'high-precedence'],
      ),
      ExampleModel(
        title: 'Nested Parens Start',
        expression: '((A+B))*C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'Double parentheses',
        expectedResult: 'AB+C*',
        tags: ['parentheses', 'nested'],
      ),
      ExampleModel(
        title: 'All Four Operators',
        expression: 'A+B-C*D/E',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.medium,
        description: 'All basic operators combined',
        expectedResult: 'AB+CD*E/-',
        tags: ['mixed', 'all-operators'],
      ),

      ExampleModel(
        title: 'Nested Parentheses',
        expression: '((A+B)*C)-D',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Multiple nested parentheses',
        expectedResult: 'AB+C*D-',
        hint: 'Process innermost parentheses first',
        tags: ['nested', 'complex'],
      ),
      ExampleModel(
        title: 'Complex Expression',
        expression: '(A+B)*(C-D)/(E+F)',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Complex expression with multiple operators',
        expectedResult: 'AB+CD-*EF+/',
        tags: ['complex', 'multiple-parens'],
      ),
      ExampleModel(
        title: 'With Exponentiation',
        expression: 'A+B*C^D-E',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Expression with power operator',
        expectedResult: 'ABCD^*+E-',
        hint: 'Exponentiation has highest precedence',
        tags: ['exponentiation', 'precedence'],
      ),
      ExampleModel(
        title: 'Deep Nesting',
        expression: '(((A+B)*C)-D)/E',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Three levels of nesting',
        expectedResult: 'AB+C*D-E/',
        tags: ['nested', 'deep'],
      ),
      ExampleModel(
        title: 'Multiple Exponents',
        expression: 'A^B^C',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Right associative exponentiation',
        expectedResult: 'ABC^^',
        hint: 'Exponentiation is right associative',
        tags: ['exponentiation', 'associativity'],
      ),
      ExampleModel(
        title: 'Complex Prefix',
        expression: '(A+B)*(C-D)',
        conversionType: 'Infix to Prefix',
        difficulty: DifficultyLevel.hard,
        description: 'Complex expression to prefix',
        expectedResult: '*+AB-CD',
        tags: ['prefix', 'complex'],
      ),
      ExampleModel(
        title: 'Long Expression',
        expression: 'A+B*C-D/E+F*G',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Seven operands with mixed operators',
        expectedResult: 'ABC*+DE/-FG*+',
        tags: ['long', 'mixed'],
      ),
      ExampleModel(
        title: 'Advanced Postfix',
        expression: 'AB+CD-*EF+/',
        conversionType: 'Postfix to Infix',
        difficulty: DifficultyLevel.hard,
        description: 'Complex postfix to infix conversion',
        expectedResult: '(((A+B)*(C-D))/(E+F))',
        tags: ['postfix', 'advanced'],
      ),
      ExampleModel(
        title: 'Prefix to Infix Hard',
        expression: '*+AB-CD',
        conversionType: 'Prefix to Infix',
        difficulty: DifficultyLevel.hard,
        description: 'Convert complex prefix to infix',
        expectedResult: '((A+B)*(C-D))',
        tags: ['prefix', 'complex'],
      ),
      ExampleModel(
        title: 'Power in Parens',
        expression: '(A+B)^(C-D)',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Exponentiation with both operands in parentheses',
        expectedResult: 'AB+CD-^',
        tags: ['exponentiation', 'parentheses'],
      ),
      ExampleModel(
        title: 'Mixed Nesting',
        expression: '((A*B)+(C/D))^E',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Nested operations with exponentiation',
        expectedResult: 'AB*CD/+E^',
        tags: ['nested', 'exponentiation'],
      ),
      ExampleModel(
        title: 'Triple Division',
        expression: '(A+B)/(C-D)/(E+F)',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Multiple divisions with parentheses',
        expectedResult: 'AB+CD-/EF+/',
        tags: ['division', 'multiple-parens'],
      ),
      ExampleModel(
        title: 'Extreme Nesting',
        expression: '((((A+B))))',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Four levels of parentheses',
        expectedResult: 'AB+',
        tags: ['nested', 'extreme'],
      ),
      ExampleModel(
        title: 'Complex Prefix Long',
        expression: '(A+B*C)/(D-E)',
        conversionType: 'Infix to Prefix',
        difficulty: DifficultyLevel.hard,
        description: 'Complex prefix with division',
        expectedResult: '/+A*BC-DE',
        tags: ['prefix', 'division', 'complex'],
      ),
      ExampleModel(
        title: 'Ultimate Challenge',
        expression: '((A+B)*(C-D))^((E/F)+(G*H))',
        conversionType: 'Infix to Postfix',
        difficulty: DifficultyLevel.hard,
        description: 'Most complex expression with all features',
        expectedResult: 'AB+CD-*EF/GH*+^',
        hint: 'Break it down into smaller parts',
        tags: ['ultimate', 'complex', 'exponentiation'],
      ),
    ];
  }

  static List<ExampleModel> getExamplesByDifficulty(DifficultyLevel difficulty) {
    return getAllExamples()
        .where((example) => example.difficulty == difficulty)
        .toList();
  }

  static List<ExampleModel> getExamplesByType(String type) {
    return getAllExamples()
        .where((example) => example.conversionType == type)
        .toList();
  }

  static List<ExampleModel> getExamplesByTag(String tag) {
    return getAllExamples()
        .where((example) => example.tags?.contains(tag) ?? false)
        .toList();
  }

  static Map<DifficultyLevel, int> getStatistics() {
    final examples = getAllExamples();
    return {
      DifficultyLevel.easy: examples.where((e) => e.difficulty == DifficultyLevel.easy).length,
      DifficultyLevel.medium: examples.where((e) => e.difficulty == DifficultyLevel.medium).length,
      DifficultyLevel.hard: examples.where((e) => e.difficulty == DifficultyLevel.hard).length,
    };
  }
}