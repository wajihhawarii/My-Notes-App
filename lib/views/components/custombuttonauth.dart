import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 400,
      height: 45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.orange,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CustomButtonUpload extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool isSelected;
  const CustomButtonUpload(
      {super.key,
      this.onPressed,
      required this.title,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: 360,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.black54,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
