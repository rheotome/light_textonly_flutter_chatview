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
import 'package:chatview/chatview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Message {
  /// Provides id
  final String id;

  /// Used for accessing widget's render box.
  final GlobalKey key;

  /// Provides actual message it will be text or image/audio file path.
  final String message;

  /// Provides message created date time.
  final DateTime createdAt;

  /// Provides id of sender of message.
  final String sendBy;

  /// Provides reply message if user triggers any reply on any message.
  final ReplyMessage replyMessage;

  /// Provides message type.
  final MessageType messageType;

  /// Status of the message.
  final ValueNotifier<MessageStatus> _status;


  Message({
    this.id = '',
    required this.message,
    required this.createdAt,
    required this.sendBy,
    this.replyMessage = const ReplyMessage(),
    this.messageType = MessageType.text,
    MessageStatus status = MessageStatus.pending,
  })  : key = GlobalKey(),
        _status = ValueNotifier(status);

  /// curret messageStatus
  MessageStatus get status => _status.value;

  /// For [MessageStatus] ValueNotfier which is used to for rebuilds
  /// when state changes.
  /// Using ValueNotfier to avoid usage of setState((){}) in order
  /// rerender messages with new receipts.
  ValueNotifier<MessageStatus> get statusNotifier => _status;

  /// This setter can be used to update message receipts, after which the configured
  /// builders will be updated.
  set setStatus(MessageStatus messageStatus) {
    _status.value = messageStatus;
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      id: json["id"],
      message: json["message"],
      createdAt: json["createdAt"],
      sendBy: json["sendBy"],
      replyMessage: ReplyMessage.fromJson(json["reply_message"]),
      messageType: json["message_type"],
      status: json['status']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt,
        'sendBy': sendBy,
        'reply_message': replyMessage.toJson(),
        'message_type': messageType,
        'status': status.name
      };
}
