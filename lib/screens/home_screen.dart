import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int) setScreen;
  final void Function(String) onModelSelected;

  const HomeScreen({
    super.key,
    required this.setScreen,
    required this.onModelSelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo
              Icon(
                Icons.sailing,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 30),
              // Title
              const Text(
                'Welcome to AI Marine Care',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Subtitle
              Text(
                'Select your yacht model to get started',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Dropdown Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Choose your model'),
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(
                      value: 'fareast28',
                      child: Text('FarEast 28'),
                    ),
                    DropdownMenuItem(
                      value: 'farr40',
                      child: Text('Farr 40'),
                    ),
                    DropdownMenuItem(
                      value: 'benetaur473',
                      child: Text('Benetaur 473'),
                    ),
                  ],
                  value: _selectedModel,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedModel = value;
                    });
                  },
                ),
              ),
              const Spacer(),
              // Continue Button
              ElevatedButton(
                onPressed: _selectedModel == null
                    ? null
                    : () {
                        widget.onModelSelected(_selectedModel!);
                        widget.setScreen(1);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
