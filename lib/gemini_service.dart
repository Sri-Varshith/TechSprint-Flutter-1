import 'dart:convert';
import 'package:http/http.dart' as http;

const String GEMINI_API_KEY = "";

Future<Map<String, dynamic>> match(String a, String b) async {
  final prompt = """
Compare the two descriptions and return ONLY valid JSON.

Description A: $a
Description B: $b

Return strictly in this format.
No markdown. No backticks. No explanation.

{
 "similarity_score": 0.0,
 "reasoning": "short explanation"
}
""";

  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$GEMINI_API_KEY",
  );

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Gemini HTTP Error ${response.statusCode}");
  }

  final raw = jsonDecode(response.body);

  final text =
      raw["candidates"][0]["content"]["parts"][0]["text"];

  final cleaned = text
      .replaceAll("```json", "")
      .replaceAll("```", "")
      .replaceAll("\n", "")
      .trim();

  return jsonDecode(cleaned);
}