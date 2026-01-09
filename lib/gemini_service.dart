import 'dart:convert';
import 'package:http/http.dart' as http;

const GEMINI_KEY = "YOUR_API_KEY";

Future<Map<String, dynamic>> match(String a, String b) async {
  final prompt = """
Compare two lost and found descriptions.

Item A: "$a"
Item B: "$b"

Return JSON with similarity_score, confidence, reasoning.
""";

  final res = await http.post(
    Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$GEMINI_KEY"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "contents": [
        {"parts": [{"text": prompt}]}
      ]
    }),
  );

  final text = jsonDecode(res.body)["candidates"][0]["content"]["parts"][0]["text"];
  return jsonDecode(text);
}