import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final Validator? validator;
  final String fieldName;
  final Map<String, dynamic>? data;
  final List<String>? autocompleteList;

  const CustomTextFormField(
      {Key? key,
      required this.labelText,
      this.keyboardType,
      this.validator,
      required this.fieldName,
      this.data,
      this.autocompleteList})
      : super(key: key);
  @override
  State createState() => _CustomTextFormField();
}

class _CustomTextFormField extends State<CustomTextFormField> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    if (widget.data != null) {
      widget.data![widget.fieldName] = _controller!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autocompleteList != null) {
      return Autocomplete<String>(
        optionsBuilder: (value) {
          return widget.autocompleteList!.where((element) =>
              element.toLowerCase().contains(value.text.toLowerCase()));
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          // _controller!.dispose();
          if (widget.data != null) {
            widget.data![widget.fieldName] = controller;
          }
          _controller = controller;
          return Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            child: TextFormField(
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: widget.labelText,
              ),
            ),
          );
        },
      );
    }
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
      child: TextFormField(
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        controller: _controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: widget.labelText,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.autocompleteList == null) {
      _controller?.dispose();
    }
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
