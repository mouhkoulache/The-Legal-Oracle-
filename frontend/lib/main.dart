import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const LegalOracleApp());

class LegalOracleApp extends StatelessWidget {
  const LegalOracleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFD4FF00),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();
  dynamic _data; // Stores the JSON analysis result
  bool _isAnalyzing = false;
  String _errorMessage = "";

  // --- THE CONNECTION SETTINGS ---
  // Using localhost because of 'adb reverse' via USB
// Update this line with your specific IP:
final String apiUrl = 'https://koulacheamine-legal-oracleai.hf.space/analyze';

  Future<void> startAudit() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _data = null;
      _errorMessage = "";
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": _controller.text}),
      ).timeout(const Duration(seconds: 120)); // Long timeout for Local AI

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded.containsKey('error')) {
          setState(() => _errorMessage = "AI Error: ${decoded['error']}");
        } else {
          setState(() => _data = decoded);
        }
      } else {
        setState(() => _errorMessage = "Server Error: ${response.statusCode}");
      }
} catch (e) {
      // This will show you exactly why it's failing (Timeout, DNS, etc.)
      setState(() => _errorMessage = "Error details: $e");
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("THE LEGAL ORACLE", 
          style: TextStyle(color: Color(0xFFD4FF00), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_data == null) ...[
              // --- INPUT SCREEN ---
              Text("Illuminate the\nFine Print.", 
                style: GoogleFonts.plusJakartaSans(fontSize: 40, fontWeight: FontWeight.w800, height: 1.1)),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                maxLines: 10,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Paste Terms and Conditions here...",
                  hintStyle: const TextStyle(color: Colors.white24),
                  fillColor: const Color(0xFF161616),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4FF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isAnalyzing ? null : startAudit,
                  child: _isAnalyzing 
                    ? const CircularProgressIndicator(color: Colors.black) 
                    : const Text("START AUDIT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),
            ] else ...[
              // --- RESULTS SCREEN ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  border: const Border(left: BorderSide(color: Color(0xFFD4FF00), width: 4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("GLOBAL RISK INDEX", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text("${_data['risk_score'] ?? 0}/100", 
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFD4FF00))),
                    ]),
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFD4FF00), size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text("ORACLE ANALYSIS", 
                style: TextStyle(color: Color(0xFFD4FF00), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text(_data['summary'] ?? "", style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.white70)),
              const SizedBox(height: 24),

              // Red Flags Card List
              if (_data['red_flags'] != null)
                ...(_data['red_flags'] as List).map((flag) => FlagCard(
                  title: flag['title'], 
                  desc: flag['explanation'], 
                  color: Colors.redAccent)),
              
              // Yellow Flags Card List
              if (_data['yellow_flags'] != null)
                ...(_data['yellow_flags'] as List).map((flag) => FlagCard(
                  title: flag['title'], 
                  desc: flag['explanation'], 
                  color: Colors.orangeAccent)),
              
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _data = null), 
                  child: const Text("ANALYZE ANOTHER DOCUMENT", style: TextStyle(color: Color(0xFFD4FF00), fontSize: 12)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// --- STYLED FLAG CARD WIDGET ---
class FlagCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color color;
  const FlagCard({super.key, required this.title, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161616), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.flag, color: color, size: 14),
            const SizedBox(width: 8),
            Text(title.toUpperCase(), 
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
          ]),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}