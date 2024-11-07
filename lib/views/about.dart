import 'package:flutter/material.dart';
import 'package:gtuner/colors/colors.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.hexColor,
                foregroundImage: const AssetImage('images/logos.png'),
                radius: 75.0,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'About',
                style: TextStyle(fontSize: 32, color: AppColors.mainColor),
              ),
              const SizedBox(height: 40),
              const Text('Made by dktomz'),
              const SizedBox(height: 40),
              const Text('Version 1.0.0')
            ],
          ),
        ),
      ),
    );
  }
}
