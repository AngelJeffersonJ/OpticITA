import 'package:flutter/material.dart';
import 'register.dart';

class UserProfile extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Function(int, Map<String, dynamic>) onUpdateUser;

  const UserProfile(this.users, {required this.onUpdateUser, Key? key})
      : super(key: key);

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                      onRegister: (userData) {},
                      initialData: user,
                      userIndex: index,
                      onUpdate: onUpdateUser,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
