import 'package:flutter/material.dart';

/// A Wrapper around TextFormField for easier use of the underlying widget and
/// uniform styling of it
class BlueshoeTextfield extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isRequired;
  final bool isArea;
  final bool? readonly;
  final FocusNode? myNode;
  final FocusNode? successorNode;
  final Widget? trailing;
  final Function(String)? onChange;
  final Function()? onEdit;
  final Function(String?)? onSaved;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  const BlueshoeTextfield(
    this.label,
    this.controller, {
    this.keyboardType,
    this.myNode,
    this.successorNode,
    this.readonly,
    this.isRequired = false,
    this.isArea = false,
    this.trailing,
    this.onChange,
    this.onEdit,
    this.onSaved,
    this.onSubmitted,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: myNode,
      keyboardType: keyboardType ?? TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction:
          successorNode != null ? TextInputAction.next : TextInputAction.done,
      readOnly: readonly ?? false,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (isRequired)
              const Text(
                "*",
                style: TextStyle(color: Colors.blue),
              ),
          ],
        ),
        suffixIcon: trailing,
      ),
      validator: validator,
      onChanged: onChange,
      onEditingComplete: onEdit,
      onSaved: onSaved,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) onSubmitted!(value);
        if (successorNode != null) {
          FocusScope.of(context).requestFocus(successorNode);
        }
      },
      maxLines: isArea ? 5 : null,
    );
  }
}
