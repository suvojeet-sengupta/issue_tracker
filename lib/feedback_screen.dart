import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _sendFeedback() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String feedback = _feedbackController.text;
      final String subject = 'App Feedback from $name';
      final String body = 'Rating: $_rating stars\n\nFeedback/Suggestions:\n$feedback\n\nName: $name';

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'suvojitsengupta21@gmail.com',
        query: encodeQueryParameters(<String, String>{
          'subject': subject,
          'body': body,
        }),
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening email client to send feedback.')),
        );
        // Optionally clear fields after opening email client
        setState(() {
          _rating = 0;
          _nameController.clear();
          _feedbackController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email client. Please ensure you have one configured.')),
        );
      }
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rate Your Experience',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 36,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          labelStyle: const TextStyle(fontFamily: 'Poppins'),
                          hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey[500]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _feedbackController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Review & Suggestions',
                          hintText: 'Share your thoughts and suggestions...', 
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 80.0), // Adjust as needed
                            child: Icon(Icons.feedback_outlined),
                          ),
                          labelStyle: const TextStyle(fontFamily: 'Poppins'),
                          hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey[500]),
                        ),
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _sendFeedback,
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
                          label: const Text(
                            'Send Feedback',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}