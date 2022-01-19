import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final Validator? validator;
  final String fieldName;
  TextEditingController? _controller;

  CustomTextFormField(
      {Key? key,
      required this.labelText,
      this.keyboardType,
      this.validator,
      required this.fieldName,
      Map<String, TextEditingController>? data})
      : super(key: key) {
    _controller = TextEditingController();
    if (data != null) {
      data[fieldName] = _controller!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
      child: TextFormField(
        keyboardType: keyboardType,
        validator: validator,
        controller: _controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}

Validator requiredValidatorWithMessage(String message) {
  return (value) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  };
}
