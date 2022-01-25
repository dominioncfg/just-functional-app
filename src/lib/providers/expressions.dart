import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';

class Expressions with ChangeNotifier {
  final List<Expression> _expressions = [];

  List<Expression> get expressions => _expressions;

  void add(String name, String formula, final List<String> variables) {
    final newId = Uuid();
    var expression = Expression(newId, name, formula, variables);
    _expressions.add(expression);
    notifyListeners();
  }

  void deleteById(Uuid id) {
    expressions.removeWhere((expression) => expression.id == id);
    notifyListeners();
  }

  Expression getById(Uuid id) =>
      _expressions.firstWhere((element) => element.id == id);

  void updateExpressiontById(
      Uuid existingId, String name, String formula, List<String> variables) {
    final existingIndex =
        _expressions.indexWhere((expression) => expression.id == existingId);

    if (existingIndex >= 0) {
      var expression = Expression(existingId, name, formula, variables);
      _expressions[existingIndex] = expression;
      notifyListeners();
    }
  }
}
