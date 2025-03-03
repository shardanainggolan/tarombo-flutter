import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonCard extends StatelessWidget {
  final String name;
  final String gender;
  final String marga;
  final String? birthDate;
  final String? photoUrl;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const PersonCard({
    Key? key,
    required this.name,
    required this.gender,
    required this.marga,
    this.birthDate,
    this.photoUrl,
    this.onTap,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo or placeholder
              _buildAvatar(),
              const SizedBox(width: 16),

              // Person info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      marga,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          gender == 'male' ? Icons.male : Icons.female,
                          size: 16,
                          color: gender == 'male' ? Colors.blue : Colors.pink,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          gender == 'male' ? 'Laki-laki' : 'Perempuan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        if (birthDate != null) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.cake,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            birthDate!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              if (actions != null && actions!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (photoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: photoUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 30, color: Colors.grey),
          ),
          errorWidget: (context, url, error) => Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade300,
            child: const Icon(Icons.error, size: 30, color: Colors.grey),
          ),
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: gender == 'male' ? Colors.blue.shade100 : Colors.pink.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.person,
          size: 30,
          color: gender == 'male' ? Colors.blue.shade900 : Colors.pink.shade900,
        ),
      );
    }
  }
}
