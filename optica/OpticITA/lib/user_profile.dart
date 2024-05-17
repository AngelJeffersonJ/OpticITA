import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const UserProfile(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user['username']),
              subtitle: Text(user['email']),
              trailing: Text(user['phone']),
            );
          },
        ),
      ),
    );
  }
}
