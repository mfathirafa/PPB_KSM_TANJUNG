import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final _fn = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text(
              'Silakan isi data diri Anda.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _fn,
              decoration: const InputDecoration(hintText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: 'Email valid'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phone,
              decoration: const InputDecoration(hintText: 'Nomor Telepon'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pwd,
              decoration: const InputDecoration(hintText: 'Password yang kuat'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_fn.text.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Isi nama')));
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dummy registered')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Next ►'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
