import 'package:flutter/material.dart';

class Dialogs {
  void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.purple.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(child: CircularProgressIndicator()));
  }
}
