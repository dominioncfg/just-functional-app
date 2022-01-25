import 'package:uuid/uuid.dart';

class Expression {
  Uuid id;
  final String name;
  final String formula;
  final List<String> variables;

  get initials {
    const maxInitialsLetters = 2;
    var words = name.split(" ");
    if (words.length > 1) {
      var str = "";
      for (var i = 0; i < words.length && i < maxInitialsLetters; i++) {
        str += words[i][0].toUpperCase();
      }
      return str;
    }

    var str = "";
    for (var i = 0; i < name.length && i < maxInitialsLetters; i++) {
      str += name[i][0].toUpperCase();
    }
    return str;
  }

  Expression(this.id, this.name, this.formula, this.variables);

  @override
  String toString() {
    return 'f(${variables.join(',')})=$formula';
  }
}
