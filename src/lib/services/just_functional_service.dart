import 'dart:convert';

import 'package:http/http.dart' as http;

import '../configuration/configuration.dart';
import '../models/models.dart';
import './responses/responses.dart';

class JustFunctionalService {
  Future<ValidationApiResponse> isValid(
      String formula, List<String> variables) async {
    Map<String, dynamic> queryParams = {
      "Expression": formula,
      "Variables": variables,
    };
    var requestUrl = Uri.parse("${ApiConstants.apiUrl}/math/validate")
        .replace(queryParameters: queryParams);

    var response = await http.get(requestUrl);

    if (response.statusCode != 200) {
      return ValidationApiResponse(false, ["To bad"]);
    }

    var responseMap = json.decode(response.body);

    var success = responseMap["success"];
    var errors = (responseMap["errors"] as List<dynamic>)
        .map((e) => e.toString())
        .toList();

    return ValidationApiResponse(success, errors);
  }

  Future<num> evaluate(
      Expression expression, Map<String, double> variablesAndValues) async {
    Map<String, String> queryParams = {
      "Expression": expression.formula,
    };

    var variablesParams = variablesAndValues
        .map((key, value) => MapEntry("Variables[$key]", value.toString()));
    queryParams.addEntries(variablesParams.entries);

    var requestUrl = Uri.parse("${ApiConstants.apiUrl}/math/evaluate")
        .replace(queryParameters: queryParams);

    var response = await http.get(requestUrl);

    if (response.statusCode != 200) {
      throw Exception("Fail to evaluate");
    }

    var responseMap = json.decode(response.body);
    var result = responseMap["result"] as num;
    return result;
  }
}
