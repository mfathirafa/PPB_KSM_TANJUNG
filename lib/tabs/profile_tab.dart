import 'package:flutter/material.dart';
import '../widgets/dialogs.dart';
import '../widgets/info_row.dart';

class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> member;
  const ProfileTab({required this.member, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, child: Text(member['name'][0])),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          member['id'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                  InfoRow(title: 'Nama Lengkap', value: member['name']),
                  const SizedBox(height: 6),
                  InfoRow(title: 'Alamat', value: member['address']),
                  const SizedBox(height: 6),
                  InfoRow(title: 'ID', value: member['id']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
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
