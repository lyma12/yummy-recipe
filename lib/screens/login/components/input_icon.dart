import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class InputIcon extends StatefulWidget {
  const InputIcon({
    super.key,
    this.paddingVertical,
    this.paddingHorizontal,
    required this.icon,
    required this.hint,
    this.stuffIcon,
    this.controller,
    this.onChange,
    this.errorText,
    this.isPassword = false,
    this.isReset = false,
  });

  final String? hint;
  final Widget icon;
  final Widget? stuffIcon;
  final String? errorText;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final bool isPassword;
  final bool isReset;

  @override
  State<StatefulWidget> createState() {
    return InputIconState();
  }
}

class InputIconState extends State<InputIcon> {
  bool _obsucureText = true;
  final TextEditingController _controller = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obsucureText = !_obsucureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReset) _controller.clear();
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          vertical: widget.paddingVertical ?? 14,
          horizontal: widget.paddingHorizontal ?? 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 239, 235, 235),
        borderRadius: BorderRadius.circular(10),
      ),
      child: widget.errorText != null
          ? TextField(
              obscureText: widget.isPassword ? _obsucureText : false,
              style: const TextStyle(fontSize: 14),
              controller: widget.controller ?? _controller,
              onChanged: widget.onChange,
              decoration: InputDecoration(
                  errorText: widget.errorText,
                  errorStyle: const TextStyle(fontSize: 11),
                  hintStyle: AppTextStyles.hintBodySmall,
                  hintText: widget.hint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: widget.icon,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(_obsucureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: _togglePasswordVisibility,
                        )
                      : widget.stuffIcon),
            )
          : TextField(
              obscureText: widget.isPassword ? _obsucureText : false,
              style: const TextStyle(fontSize: 14),
              controller: widget.controller ?? _controller,
              onChanged: widget.onChange,
              decoration: InputDecoration(
                  hintStyle: AppTextStyles.hintBodySmall,
                  hintText: widget.hint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: widget.icon,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(_obsucureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: _togglePasswordVisibility,
                        )
                      : widget.stuffIcon),
            ),
    );
  }
}
