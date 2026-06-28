import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Configuration for the backend API URL.
// Use 'http://10.0.2.2:8000/recommend' for Android emulator to connect to localhost.
// Replace with your public Render URL after deployment (e.g. 'https://api-service.onrender.com/recommend').
const String backendUrl = 'http://10.0.2.2:8000/recommend';

void main() {
  runApp(const AccessibilityApp());
}

class AccessibilityApp extends StatelessWidget {
  const AccessibilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accessibility Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981), // Emerald green base theme
          brightness: Brightness.light,
        ),
      ),
      home: const SelectionScreen(),
    );
  }
}

// Screen 1: Selection and Input Screen
class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  
  String? _selectedDisability;

  // List of available disability categories with corresponding UI icons
  final List<Map<String, dynamic>> _disabilities = [
    {'name': 'Visual', 'icon': Icons.visibility},
    {'name': 'Mobility', 'icon': Icons.accessible},
    {'name': 'Hearing', 'icon': Icons.hearing},
    {'name': 'Cognitive', 'icon': Icons.psychology},
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_selectedDisability == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a disability type first.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationsScreen(
            disabilityType: _selectedDisability!,
            userQuery: _queryController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Grid layout for category choices
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: _disabilities.length,
                  itemBuilder: (context, index) {
                    final item = _disabilities[index];
                    final isSelected = _selectedDisability == item['name'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDisability = item['name'];
                        });
                      },
                      child: Card(
                        elevation: isSelected ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primaryContainer 
                            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'], 
                              size: 32, 
                              color: isSelected 
                                  ? Theme.of(context).colorScheme.primary 
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 28),
                const Text(
                  'What do you need help with?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Multiline text input field
                TextFormField(
                  controller: _queryController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe the task or support needed (e.g. read screen text, navigate streets, hear video calls)...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description of your request.';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Continue Button
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Get Recommendations', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Screen 2: Recommendations and API Connection Screen
class RecommendationsScreen extends StatefulWidget {
  final String disabilityType;
  final String userQuery;

  const RecommendationsScreen({
    super.key,
    required this.disabilityType,
    required this.userQuery,
  });

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // API Call implementation
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'disability_type': widget.disabilityType,
          'user_query': widget.userQuery,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        setState(() {
          _recommendations = decodedData['recommendations'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Server response error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to connect to service. Make sure the API server is active.';
        _isLoading = false;
      });
    }
  }

  // Maps backend icon string values to material UI IconData
  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'record_voice_over': return Icons.record_voice_over;
      case 'document_scanner': return Icons.document_scanner;
      case 'explore': return Icons.explore;
      case 'vibration': return Icons.vibration;
      case 'zoom_in': return Icons.zoom_in;
      case 'contrast': return Icons.contrast;
      case 'mic': return Icons.mic;
      case 'settings_remote': return Icons.settings_remote;
      case 'touch_app': return Icons.touch_app;
      case 'mouse': return Icons.mouse;
      case 'closed_caption': return Icons.closed_caption;
      case 'speech_to_text': return Icons.keyboard_voice;
      case 'flashing_lights': return Icons.light_mode;
      case 'chrome_reader_mode': return Icons.chrome_reader_mode;
      case 'notifications_off': return Icons.notifications_off;
      case 'widgets': return Icons.widgets;
      case 'calendar_today': return Icons.calendar_today;
      default: return Icons.accessibility_new;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display chosen query preview
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category: ${widget.disabilityType}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${widget.userQuery}"',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading / Error / Data Switch
            Expanded(
              child: _buildStateView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateView() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Finding solutions...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_recommendations.isEmpty) {
      return const Center(
        child: Text('No recommendations found for this query.'),
      );
    }

    return ListView.builder(
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final rec = _recommendations[index];
        final iconData = _mapIcon(rec['icon'] ?? '');

        return Card(
          elevation: 1.5,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    color: Theme.of(context).colorScheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec['title'] ?? 'Recommendation',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        rec['description'] ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
