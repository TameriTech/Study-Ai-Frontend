import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FileCard extends StatelessWidget {
  final int? id;
  final String title;
  final String? subtitle;
  final String? level;
  final Color color;
  final double? progress;
  final String timeInfo;
  final String type;
  final String? textPreview;
  final String createdAt;

  const FileCard({
    super.key,
    required this.title,
    this.subtitle,
    this.level,
    required this.color,
    this.progress,
    required this.timeInfo,
    required this.type,
    this.textPreview,
    this.id,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.035;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 0,
              maxHeight: constraints.maxHeight, // Keeps it inside bounds
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: baseFontSize + 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  /// File Type
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  /// Text preview
                  if (textPreview != null)
                    Expanded(
                      child: Text(
                        textPreview!,
                        style: TextStyle(
                          fontSize: baseFontSize,
                          color: Colors.black87,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    const Spacer(),

                  /// Level
                  if (level != null)
                    Text(
                      level!,
                      style: TextStyle(
                        fontSize: baseFontSize,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 8),

                  /// Bottom row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          timeInfo,
                          style: TextStyle(
                            fontSize: baseFontSize - 2,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      if (progress != null)
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Text(
                            "${(progress! * 100).toInt()}%",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




