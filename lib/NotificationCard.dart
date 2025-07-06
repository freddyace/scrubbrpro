import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({super.key, required this.notification});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isPressed = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isUnread = !(widget.notification['isRead'] ?? false);
    final description = widget.notification['description'] ?? '';
    final isExpandable = description.length > 40;

    final displayedDescription = !_isExpanded && isExpandable
        ? '${description.substring(0, 37)}...'
        : description;

    return GestureDetector(
      onTap: () {
        setState(() => _isPressed = true);
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _isPressed = false;

            if (isExpandable) {
              // If expandable, toggle expansion then mark as read on second tap
              if (!_isExpanded) {
                _isExpanded = true;
              } else {
                _isExpanded = false;
                widget.notification['isRead'] = true;
              }
            } else {
              // If not expandable, mark as read immediately
              widget.notification['isRead'] = true;
            }
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isUnread
                  ? (_isPressed ? Colors.blueAccent.withOpacity(0.3) : Colors.blueAccent.withOpacity(0.5))
                  : (_isPressed ? Colors.black26 : Colors.black12),
              blurRadius: _isPressed ? 4 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.notification['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayedDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.notification['time'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white30 : Colors.grey,
                  ),
                ),
              ],
            ),

            // Gradient unread dot indicator (top-right)
            if (isUnread)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
