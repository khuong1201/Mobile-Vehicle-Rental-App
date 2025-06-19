import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onReload;

  const EmptyListScreen({
    super.key,
    this.message = "Không có dữ liệu để hiển thị.",
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (onReload != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onReload,
              child: Text("Tải lại"),
            ),
          ]
        ],
      ),
    );
  }
}