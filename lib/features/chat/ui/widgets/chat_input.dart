import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.callback});
  final void Function(String text) callback;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type message...',
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final text = _controller.text;
              if (text.isNotEmpty) {
                widget.callback(text);
                _controller.clear();
              }
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
