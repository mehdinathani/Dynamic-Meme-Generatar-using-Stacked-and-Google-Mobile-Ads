import 'package:flutter/material.dart';

class CustomDrawerButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String text;
  const CustomDrawerButton(
      {super.key, this.onTap, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
