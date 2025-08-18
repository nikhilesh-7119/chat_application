import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final String? suffix;
  final VoidCallback? suffixAction;
  final Widget Function()? button;
  final VoidCallback? buttonAction;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.suffix,
    this.suffixAction,
    this.button,
    this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    final inputborder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );

    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        filled: true,
        suffix: suffix != null
            ? GestureDetector(
                onTap: suffixAction,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    suffix!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : null,
        suffixIcon: button != null
            ? IconButton(onPressed: buttonAction, icon: button!())
            : null,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
