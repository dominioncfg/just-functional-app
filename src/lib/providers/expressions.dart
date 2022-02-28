import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';

class Expressions with ChangeNotifier {
  final _idGenerator = const Uuid();
  final ExpressionsRepository _repository = ExpressionsRepository();
  List<Expression> _expressions = [];

  List<Expression> get expressions => _expressions;

  Future<void> add(
      String name, String formula, final List<String> variables) async {
    var newId = _idGenerator.v4();
    var expression = Expression(newId, name, formula, variables);
    await _repository.addOrUpdate(expression);
    _expressions.add(expression);
    notifyListeners();
  }

  Future<void> deleteById(String id) async {
    await _repository.deleteById(id);
    expressions.removeWhere((expression) => expression.id == id);
    notifyListeners();
  }

  Expression getById(String id) =>
      _expressions.firstWhere((element) => element.id == id);

  Future<void> updateExpressiontById(String existingId, String name,
      String formula, List<String> variables) async {
    final existingIndex =
        _expressions.indexWhere((expression) => expression.id == existingId);

    if (existingIndex >= 0) {
      var expression = Expression(existingId, name, formula, variables);
      await _repository.addOrUpdate(expression);
      _expressions[existingIndex] = expression;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetExistingExpression() async {
    var expressions = await _repository.getAll();
    _expressions = expressions;
  }
}
