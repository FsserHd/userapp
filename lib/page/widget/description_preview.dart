


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';

import '../../constants/app_style.dart';

class DescriptionPreview extends StatelessWidget {
  final String description;

  const DescriptionPreview({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Detect if text overflows
        final textPainter = TextPainter(
          text: TextSpan(
            text: description,
            style: AppStyle.font14MediumBlack87.override(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth - 30); // leave space for "more"

        final isOverflowing = textPainter.didExceedMaxLines;

        return GestureDetector(
          onTap: () {

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Description',style: AppStyle.font14MediumBlack87.override(
                      fontSize: 14,
                    ),),
                    content: Text(description,style: AppStyle.font14MediumBlack87.override(
                      fontSize: 12,
                      color: Colors.grey,
                    ),),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
          },
          child: Container(
            width: 140,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.font14MediumBlack87.override(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                if (description.length > 40)
                  Text(
                    ' more',
                    style: AppStyle.font14MediumBlack87.override(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
