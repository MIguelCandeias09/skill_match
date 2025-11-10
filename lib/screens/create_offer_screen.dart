import 'package:flutter/material.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Offer'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'What can you teach?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A4FFF),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Skill to Offer',
                  prefixIcon: Icon(Icons.school_outlined),
                  hintText: 'e.g., Guitar Lessons',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                  hintText: 'Describe your experience and teaching style',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              const Text(
                'What would you like to learn?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A4FFF),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Desired Skill',
                  prefixIcon: Icon(Icons.psychology_outlined),
                  hintText: 'e.g., Cooking Classes',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Preferred Location',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'Where would you like to meet?',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle offer creation
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: const Text('Create Offer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
