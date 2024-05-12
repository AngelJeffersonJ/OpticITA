import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String username;
  final String email;

  const UserProfile({Key? key, required this.username, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Configuración'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.pushNamed(context,
                  '/configuracion'); // Navega a la pantalla de configuración
            },
          ),
          ListTile(
            title: Text('Ayuda'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.pushNamed(
                  context, '/ayuda'); // Navega a la pantalla de ayuda
            },
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            onTap: () {
              // Aquí puedes agregar la lógica para cerrar sesión, por ejemplo, mostrar un diálogo de confirmación
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Cerrar Sesión'),
                    content:
                        Text('¿Estás seguro de que quieres cerrar sesión?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Agrega la lógica para cerrar sesión aquí, como limpiar los datos de autenticación y navegar a la pantalla de inicio de sesión
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) =>
                                  false); // Navega a la pantalla de inicio de sesión y elimina todas las rutas anteriores
                        },
                        child: Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
