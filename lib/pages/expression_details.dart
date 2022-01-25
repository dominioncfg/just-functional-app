import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'pages.dart';
import '../providers/expressions.dart';
import '../models/expression.dart';

class ExpressionDetailsPage extends StatelessWidget {
  static const route = "/details";
  const ExpressionDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expressionId = ModalRoute.of(context)!.settings.arguments as Uuid;
    var expressionData = Provider.of<Expressions>(context);
    var expression = expressionData.getById(expressionId);

    return Scaffold(
      appBar: AppBar(
        title: Text(expression.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                ExpressionEditPage.route,
                arguments: expressionId,
              );
            },
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: _ExpressionEvaluator(
        expression: expression,
      ),
    );
  }
}

class _ExpressionEvaluator extends StatefulWidget {
  final Expression expression;

  const _ExpressionEvaluator({Key? key, required this.expression})
      : super(key: key);

  @override
  State<_ExpressionEvaluator> createState() => __ExpressionEvaluatorState();
}

class __ExpressionEvaluatorState extends State<_ExpressionEvaluator> {
  final _form = GlobalKey<FormState>();
  final _variablesMap = <String, double>{};
  final _results = <_EvaluationResultItem>[];

  TextFormField _getVariableTextField(String variableName, bool isLastOne) {
    return TextFormField(
      decoration: InputDecoration(labelText: variableName),
      keyboardType: TextInputType.number,
      textInputAction: isLastOne ? TextInputAction.done : TextInputAction.next,
      validator: (value) {
        if (double.tryParse(value ?? "") == null) {
          return 'Please provide a valid number.';
        }
        return null;
      },
      onSaved: (value) {
        _variablesMap[variableName] = double.parse(value ?? "0");
      },
      onFieldSubmitted: (_) {},
    );
  }

  Widget _getEvaluateForm(BuildContext context) {
    var textFieldList = <Widget>[];
    var variables = widget.expression.variables.toList();
    for (var i = 0; i < variables.length; i++) {
      bool isLastTextField = i == variables.length - 1;

      var variable = variables[i];
      var textField = _getVariableTextField(variable, isLastTextField);

      textFieldList.add(textField);
    }

    return Form(
        key: _form,
        child: Column(
          children: [
            ...textFieldList,
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _evaluateExpression,
              child: const Text(
                "Evaluate",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ));
  }

  void _evaluateExpression() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    var variables = _variablesMap.values.toList();

    setState(() {
      _results.add(_EvaluationResultItem(widget.expression, variables, 4));
      _form.currentState!.reset();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              '${widget.expression}',
              style: Theme.of(context).textTheme.headline4,
            ),
            _getEvaluateForm(context),
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (ctx, i) {
                  final _EvaluationResultItem resultItem = _results[i];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        "f(${resultItem.variablesValues.join(',')})=${resultItem.result}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvaluationResultItem {
  final Expression expression;
  final List<double> variablesValues;
  final double result;

  const _EvaluationResultItem(
      this.expression, this.variablesValues, this.result);
}