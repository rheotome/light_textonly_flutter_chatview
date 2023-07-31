/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:async';
import 'dart:io' show Platform;

import 'package:chatview/src/utils/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../chatview.dart';
import '../utils/debounce.dart';
import '../utils/package_strings.dart';

class ChatUITextField extends StatefulWidget {
  const ChatUITextField({
    Key? key,
    this.sendMessageConfig,
    required this.focusNode,
    required this.textEditingController,
    required this.onPressed,
  }) : super(key: key);

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides focusNode for focusing text field.
  final FocusNode focusNode;

  /// Provides functions which handles text field.
  final TextEditingController textEditingController;

  /// Provides callback when user tap on text field.
  final VoidCallBack onPressed;

  @override
  State<ChatUITextField> createState() => _ChatUITextFieldState();
}

class _ChatUITextFieldState extends State<ChatUITextField> {
  final ValueNotifier<String> _inputText = ValueNotifier('');

  SendMessageConfiguration? get sendMessageConfig => widget.sendMessageConfig;

  TextFieldConfiguration? get textFieldConfig =>
      sendMessageConfig?.textFieldConfig;

  OutlineInputBorder get _outLineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
      );


  late Debouncer debouncer;

  @override
  void initState() {
    attachListeners();
    debouncer = Debouncer(
        sendMessageConfig?.textFieldConfig?.compositionThresholdTime ??
            const Duration(seconds: 1));
    super.initState();

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      ///
    }
  }

  @override
  void dispose() {
    debouncer.dispose();
    _inputText.dispose();
    super.dispose();
  }

  void attachListeners() {
// if we ever want 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: textFieldConfig?.padding ??
            const EdgeInsets.symmetric(horizontal: 6),
        margin: textFieldConfig?.margin,
        decoration: BoxDecoration(
          borderRadius: textFieldConfig?.borderRadius ??
              BorderRadius.circular(textFieldBorderRadius),
          color: sendMessageConfig?.textFieldBackgroundColor ?? Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
                controller: widget.textEditingController,
                style: textFieldConfig?.textStyle ??
                    const TextStyle(color: Colors.white),
                maxLines: textFieldConfig?.maxLines ?? 5,
                minLines: textFieldConfig?.minLines ?? 1,
                keyboardType: textFieldConfig?.textInputType,
                inputFormatters: textFieldConfig?.inputFormatters,
                onChanged: _onChanged,
                textCapitalization: textFieldConfig?.textCapitalization ??
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: textFieldConfig?.hintText ?? PackageStrings.message,
                  fillColor: sendMessageConfig?.textFieldBackgroundColor ??
                      Colors.white,
                  filled: true,
                  hintStyle: textFieldConfig?.hintStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.25,
                      ),
                  contentPadding: textFieldConfig?.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 6),
                  border: _outLineBorder,
                  focusedBorder: _outLineBorder,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: textFieldConfig?.borderRadius ??
                        BorderRadius.circular(textFieldBorderRadius),
                  ),
                ),
              ),
            ),
            IconButton(
              color: sendMessageConfig?.defaultSendButtonColor ?? Colors.green,
              onPressed: () {
                widget.onPressed();
                _inputText.value = '';
              },
              icon: sendMessageConfig?.sendButtonIcon ?? const Icon(Icons.send),
            ),
          ],
        ));
  }


  void _onChanged(String inputText) {
    _inputText.value = inputText;
  }
}
