import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../services/services.dart';

class ExpressionEdit extends StatefulWidget {
  const ExpressionEdit({Key? key}) : super(key: key);

  @override
  State<ExpressionEdit> createState() => _ExpressionEditState();
}

class _ExpressionEditState extends State<ExpressionEdit> {
  final _form = GlobalKey<FormState>();
  final _formulaFocusNode = FocusNode();
  final _justFunctionalService = JustFunctionalService();
  _NewExpressionData _formData = _NewExpressionData();

  Future<void> _createExpression(Expressions expressionsData) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    var editingExpessionId = _formData.editingExpessionId;
    final name = _formData.name ?? "";
    final formula = _formData.formula ?? "";
    final variables = _formData.variables;
    bool isAdd = editingExpessionId == null;
    final isAValidExpressionResult =
        await _justFunctionalService.isValid(formula, variables);

    if (!isAValidExpressionResult.success) {
      var errorStr = isAValidExpressionResult.errors.join(". ");
      var snackBar = SnackBar(
          content: Text(errorStr),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Theme.of(context).primaryColorDark);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (isAdd) {
      await expressionsData.add(name, formula, variables);
    } else {
      await expressionsData.updateExpressiontById(
          editingExpessionId, name, formula, variables);
    }

    Navigator.of(context).pop();
  }

  void _createVariable(BuildContext ctx) async {
    var name = await showModalBottomSheet<String>(
      context: ctx,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: _AddVariable(existingVariables: _formData.variables),
          behavior: HitTestBehavior.opaque,
        );
      },
    );

    if (name != null) {
      setState(() {
        _formData.addVariable(name);
      });
    }
  }

  void _removeVariableByName(String name) {
    setState(() {
      _formData.removeVariable(name);
    });
  }

  void _cancel(BuildContext ctx) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final expressionsData = Provider.of<Expressions>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: <Widget>[
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _formData.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please provide an expression name.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _formData.name = value;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_formulaFocusNode);
                          },
                        ),
                        TextFormField(
                          initialValue: _formData.formula,
                          decoration:
                              const InputDecoration(labelText: 'Formula'),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          focusNode: _formulaFocusNode,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please provide a formula.';
                            }
                          },
                          onSaved: (value) {
                            _formData.formula = value;
                          },
                          onFieldSubmitted: (_) {},
                        ),
                      ],
                    )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => _createVariable(context),
                      child: const Text('Add Variable'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: ListView.builder(
                      itemCount: _formData.variables.length,
                      itemBuilder: (ctx, i) {
                        final String variableName = _formData.variables[i];
                        return _VariableItem(
                          key: Key(variableName),
                          variableName: variableName,
                          deleteCallback: _removeVariableByName,
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => {_cancel(context)},
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async =>
                          {await _createExpression(expressionsData)},
                      child: Text(
                        _formData.editingExpessionId == null
                            ? "Create"
                            : "Save",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final arg = ModalRoute.of(context)!.settings.arguments;
      if (arg != null && arg is String) {
        final editedExpression =
            Provider.of<Expressions>(context, listen: false).getById(arg);

        _formData = _NewExpressionData(editingExpessionId: editedExpression.id);
        _formData.name = editedExpression.name;
        _formData.formula = editedExpression.formula;
        _formData.loadInitialVariables(editedExpression.variables);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _formulaFocusNode.dispose();
    super.dispose();
  }
}

class _VariableItem extends StatelessWidget {
  final String variableName;
  final Function deleteCallback;
  const _VariableItem({
    Key? key,
    required this.variableName,
    required this.deleteCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 8,
      ),
      child: ListTile(
        title: Text(
          variableName,
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          color: Theme.of(context).errorColor,
          onPressed: () => deleteCallback(variableName),
        ),
      ),
    );
  }
}

class _AddVariable extends StatefulWidget {
  final List<String> existingVariables;
  const _AddVariable({Key? key, required this.existingVariables})
      : super(key: key);

  @override
  __AddVariableState createState() => __AddVariableState();
}

class __AddVariableState extends State<_AddVariable> {
  final _form = GlobalKey<FormState>();
  String _variableText = "";
  @override
  Widget build(BuildContext context) {
    void _createVariable() {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      _form.currentState!.save();
      Navigator.of(context).pop(_variableText);
    }

    return SingleChildScrollView(
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Variable Name'),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide a valid variable name.';
                    }

                    final bool variableAlreadyExist = widget.existingVariables
                        .any((element) => element == value);

                    if (variableAlreadyExist) {
                      return 'Variable already exist.';
                    }

                    return null;
                  },
                  onSaved: (newValue) => {_variableText = newValue ?? ""},
                  onFieldSubmitted: (_) {
                    _createVariable();
                  },
                ),
                ElevatedButton(
                    onPressed: () => {_createVariable()},
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewExpressionData {
  final String? editingExpessionId;
  String? _name;
  String? _formula;
  final List<String> _variables = [];

  _NewExpressionData({this.editingExpessionId});

  String? get name => _name;
  set name(newName) => _name = newName;
  String? get formula => _formula;
  set formula(newFormula) => _formula = newFormula;

  List<String> get variables => _variables;
  void loadInitialVariables(List<String> vars) {
    for (var variable in vars) {
      addVariable(variable);
    }
  }

  void addVariable(String newVariable) => _variables.add(newVariable);
  void removeVariable(String name) =>
      _variables.removeWhere((element) => element == name);
}
