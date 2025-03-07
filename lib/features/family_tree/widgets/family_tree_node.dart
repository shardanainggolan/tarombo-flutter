// lib/features/family_tree/widgets/family_tree_node.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarombo/features/family_tree/models/family_graph.dart';

class FamilyTreeNode extends StatelessWidget {
  final GraphNode node;
  final bool isCentral;
  final Map<int, String> relationshipTerms;

  const FamilyTreeNode({
    Key? key,
    required this.node,
    required this.isCentral,
    required this.relationshipTerms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine gender-based styling
    final gender = node.data.gender?.toLowerCase() ?? 'unknown';

    final Color nodeColor = gender == 'male'
        ? Colors.blue.shade100
        : (gender == 'female' ? Colors.pink.shade100 : Colors.grey.shade200);

    final Color borderColor = isCentral ? Colors.red : Colors.grey;

    // Get relationship term for this person
    final relationshipTerm = relationshipTerms[node.id];

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go('/person/${node.id}');
      },
      child: Container(
        width: 120,
        height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: nodeColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: isCentral ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gender icon
            Icon(
              gender == 'male'
                  ? Icons.male
                  : (gender == 'female' ? Icons.female : Icons.person),
              color: gender == 'male'
                  ? Colors.blue.shade800
                  : (gender == 'female'
                      ? Colors.pink.shade800
                      : Colors.grey.shade800),
              size: 20,
            ),
            const SizedBox(height: 4),

            // Person name
            Text(
              node.label ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Marga name
            Text(
              node.data.marga ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Relationship term (partuturan)
            if (relationshipTerm != null && !isCentral) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  relationshipTerm,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // Star for central person
            if (isCentral)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.star, color: Colors.amber, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
