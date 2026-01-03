import 'package:flutter/material.dart';
import '../widgets/dialogs.dart';
import '../widgets/info_row.dart';

class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> member;
  const ProfileTab({required this.member, super.key});

  @override
  Widget build(BuildContext context) {
    final String name = member['name'] ?? '-';
    final String phone = member['phone'] ?? '-';
    final String alamat = member['pelanggan']?['alamat'] ?? '-';
    final String userId = member['id'].toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ================= HEADER CARD ================= */
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'User ID: $userId',
                          style:
                              const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /* ================= INFORMASI PELANGGAN ================= */
          const Text(
            'Informasi Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(title: 'Nama Lengkap', value: name),
                  const SizedBox(height: 6),
                  InfoRow(title: 'No. WhatsApp', value: phone),
                  const SizedBox(height: 6),
                  InfoRow(title: 'Alamat', value: alamat),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /* ================= LOGOUT ================= */
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => LogoutConfirmationDialog(),
                );
              },
              child: const Text('Logout'),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}