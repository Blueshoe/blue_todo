import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BlueshoeDatefield extends StatelessWidget {
  final String label;
  final String? value;
  final void Function()? onDate;
  final void Function()? onClear;

  const BlueshoeDatefield(
    this.label,
    this.value,
    this.onDate, {
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: InputDecorator(
        expands: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          constraints: BoxConstraints.expand(
            height: 56.0,
            width: MediaQuery.sizeOf(context).width,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null && value != "-" && onClear != null)
                IconButton(
                  icon: Icon(MdiIcons.close),
                  onPressed: onClear,
                ),
              IconButton(
                icon: Icon(MdiIcons.calendarEdit),
                onPressed: onDate,
              ),
            ],
          ),
        ),
        child: Text(value ?? "-"),
      ),
    );
  }
}
