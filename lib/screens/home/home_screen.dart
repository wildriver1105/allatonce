import 'package:flutter/material.dart';
import '../../constants/colors.dart';

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
                    DropdownMenuItem(
                      value: 'j24',
                      child: Text('J/24'),
                    ),
                    DropdownMenuItem(
                      value: 'laser',
                      child: Text('Laser'),
                    ),
                    DropdownMenuItem(
                      value: 'swan50',
                      child: Text('Swan 50'),
                    ),
                    DropdownMenuItem(
                      value: 'x35',
                      child: Text('X-35'),
                    ),
                    DropdownMenuItem(
                      value: 'melges32',
                      child: Text('Melges 32'),
                    ),
                    DropdownMenuItem(
                      value: 'tp52',
                      child: Text('TP52'),
                    ),
                    DropdownMenuItem(
                      value: 'first36',
                      child: Text('Beneteau First 36'),
                    ),
                    DropdownMenuItem(
                      value: 'sunfast3300',
                      child: Text('Jeanneau Sun Fast 3300'),
                    ),
                    DropdownMenuItem(
                      value: 'dehler38',
                      child: Text('Dehler 38'),
                    ),
                    DropdownMenuItem(
                      value: 'xp44',
                      child: Text('X-Yachts XP 44'),
                    ),
                    DropdownMenuItem(
                      value: 'hanse458',
                      child: Text('Hanse 458'),
                    ),
                    DropdownMenuItem(
                      value: 'oceanis46',
                      child: Text('Beneteau Oceanis 46'),
                    ),
                    DropdownMenuItem(
                      value: 'swan48',
                      child: Text('Nautor Swan 48'),
                    ),
                    DropdownMenuItem(
                      value: 'gc42',
                      child: Text('Grand Soleil GC 42'),
                    ),
                    DropdownMenuItem(
                      value: 'rs21',
                      child: Text('RS21'),
                    ),
                    DropdownMenuItem(
                      value: 'j70',
                      child: Text('J/70'),
                    ),
                    DropdownMenuItem(
                      value: 'solaris44',
                      child: Text('Solaris 44'),
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
