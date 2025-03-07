// lib/features/family_tree/widgets/marriage_box_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarombo/features/family_tree/utils/family_tree_layout.dart';
import 'package:tarombo/features/family_tree/models/family_graph.dart';

class MarriageBoxWidget extends StatelessWidget {
  final MarriageGroup marriageGroup;
  final Map<int, GraphNode> nodeMap;

  const MarriageBoxWidget({
    Key? key,
    required this.marriageGroup,
    required this.nodeMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (marriageGroup.bounds == Rect.zero) {
      print("⚠️ Marriage box has zero bounds - not rendering");
      return const SizedBox.shrink();
    }

    // Get both spouse nodes
    final spouse1 = nodeMap[marriageGroup.person1Id];
    final spouse2 = nodeMap[marriageGroup.person2Id];

    // Skip if either spouse is missing
    if (spouse1 == null || spouse2 == null) {
      print("⚠️ Marriage box missing spouse nodes");
      return const SizedBox.shrink();
    }

    print("Rendering marriage box at: ${marriageGroup.bounds}");

    final bool isDivorced = marriageGroup.divorceDate != null;
    final bool isCurrentMarriage = marriageGroup.isCurrentMarriage;

    // Skip if either spouse is missing
    if (spouse1 == null || spouse2 == null) {
      return const SizedBox.shrink();
    }

    // Determine if this is a mixed-gender marriage for styling
    final bool isMixedGender =
        spouse1.data.gender.toLowerCase() != spouse2.data.gender.toLowerCase();

    // Create a decorated container for the marriage
    // Create a decorated container for the marriage
    return Positioned(
      left: marriageGroup.bounds.left,
      top: marriageGroup.bounds.top,
      width: marriageGroup.bounds.width,
      height: marriageGroup.bounds.height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: isDivorced
                ? Colors.grey.withOpacity(0.5)
                : (isMixedGender
                    ? Colors.red.withOpacity(0.5)
                    : Colors.purple.withOpacity(0.5)),
            width: isCurrentMarriage ? 2 : 1,
            style: isDivorced ? BorderStyle.solid : BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isDivorced
                  ? Colors.grey.shade50
                  : (isMixedGender
                      ? Colors.red.shade50
                      : Colors.purple.shade50),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDivorced ? Icons.link_off : Icons.favorite,
                  size: 10,
                  color: isDivorced
                      ? Colors.grey.shade700
                      : (isMixedGender
                          ? Colors.red.shade700
                          : Colors.purple.shade700),
                ),
                const SizedBox(width: 2),
                Text(
                  isDivorced ? 'Former Marriage' : 'Marriage',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDivorced
                        ? Colors.grey.shade700
                        : (isMixedGender
                            ? Colors.red.shade900
                            : Colors.purple.shade900),
                  ),
                ),
                if (marriageGroup.marriageDate != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(${DateFormat('yyyy').format(marriageGroup.marriageDate!)})',
                    style: TextStyle(
                      fontSize: 8,
                      color: isDivorced
                          ? Colors.grey.shade600
                          : (isMixedGender
                              ? Colors.red.shade700
                              : Colors.purple.shade700),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
