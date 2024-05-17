import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class RegisterScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onRegister;
  final Map<String, dynamic>? initialData;
  final int? userIndex;
  final Function(int, Map<String, dynamic>)? onUpdate;

  RegisterScreen({
    required this.onRegister,
    this.initialData,
    this.userIndex,
    this.onUpdate,
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _usernameController.text = widget.initialData!['username'];
      _emailController.text = widget.initialData!['email'];
      _phoneController.text = widget.initialData!['phone'];
      _passwordController.text = widget.initialData!['password'];
      _confirmPasswordController.text = widget.initialData!['password'];
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String fileContent = utf8.decode(file.bytes!);
      Map<String, dynamic> jsonData = jsonDecode(fileContent);
      setState(() {
        _usernameController.text = jsonData['username'] ?? '';
        _emailController.text = jsonData['email'] ?? '';
        _phoneController.text = jsonData['phone'] ?? '';
        _passwordController.text = jsonData['password'] ?? '';
        _confirmPasswordController.text = jsonData['password'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialData == null ? 'Registrarse' : 'Actualizar Datos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  icon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadFromFile,
                child: Text('Cargar desde archivo JSON'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_passwordController.text ==
                      _confirmPasswordController.text) {
                    Map<String, dynamic> userData = {
                      'username': _usernameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'password': _passwordController.text,
                    };
                    if (widget.initialData == null) {
                      widget.onRegister(userData);
                    } else {
                      widget.onUpdate!(widget.userIndex!, userData);
                    }
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Las contraseñas no coinciden.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                    widget.initialData == null ? 'Registrarse' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
