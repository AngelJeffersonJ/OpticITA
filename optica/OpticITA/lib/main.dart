import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda de Lentes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatalogoLentes(),
    );
  }
}

class CatalogoLentes extends StatefulWidget {
  @override
  _CatalogoLentesState createState() => _CatalogoLentesState();
}

class _CatalogoLentesState extends State<CatalogoLentes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _selectedIndex;
  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> resenas = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _loadUsers();
    _loadReviews();
  }

  void _loadUsers() async {
    try {
      final file = File('usuarios.json');
      if (await file.exists()) {
        final usersData = await file.readAsString();
        setState(() {
          usuarios = List<Map<String, dynamic>>.from(jsonDecode(usersData));
        });
      }
    } catch (e) {
      print("Error cargando usuarios: $e");
    }
  }

  void _saveUser(Map<String, dynamic> userData) async {
    try {
      usuarios.add(userData);
      final file = File('usuarios.json');
      await file.writeAsString(jsonEncode(usuarios));
    } catch (e) {
      print("Error guardando usuario: $e");
    }
  }

  void _loadReviews() async {
    try {
      final file = File('resenas.xml');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final document = xml.XmlDocument.parse(contents);
        setState(() {
          resenas = _parseReviews(document);
        });
      }
    } catch (e) {
      print("Error cargando reseñas: $e");
    }
  }

  List<Map<String, dynamic>> _parseReviews(xml.XmlDocument document) {
    final reviews = <Map<String, dynamic>>[];
    final elements = document.findAllElements('review');
    for (var element in elements) {
      final username = element.findElements('username').single.text;
      final reviewText = element.findElements('text').single.text;
      reviews.add({
        'username': username,
        'review': reviewText,
      });
    }
    return reviews;
  }

  void _saveReview(String username, String reviewText) async {
    try {
      final file = File('reseñas.xml');
      final document = await _getOrCreateXmlDocument(file);
      final reviewsElement = document.findElements('reviews').single;
      final newReview = xml.XmlElement(
        xml.XmlName('review'),
        [],
        [
          xml.XmlElement(xml.XmlName('username'), [], [xml.XmlText(username)]),
          xml.XmlElement(xml.XmlName('text'), [], [xml.XmlText(reviewText)]),
        ],
      );
      reviewsElement.children.add(newReview);
      await file.writeAsString(document.toXmlString(pretty: true));
      setState(() {
        resenas.add({
          'username': username,
          'review': reviewText,
        });
      });
    } catch (e) {
      print("Error guardando reseña: $e");
    }
  }

  Future<xml.XmlDocument> _getOrCreateXmlDocument(File file) async {
    if (await file.exists()) {
      final contents = await file.readAsString();
      return xml.XmlDocument.parse(contents);
    } else {
      return xml.XmlDocument([
        xml.XmlProcessing('xml', 'version="1.0"'),
        xml.XmlElement(
          xml.XmlName('reviews'),
          [],
          [],
        ),
      ]);
    }
  }

  void _updateUser(int index, Map<String, dynamic> userData) async {
    try {
      usuarios[index] = userData;
      final file = File('usuarios.json');
      await file.writeAsString(jsonEncode(usuarios));
    } catch (e) {
      print("Error actualizando usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Catálogo de Lentes'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegisterScreen(onRegister: _saveUser)),
              );
            },
          ),
          PopupMenuButton<int>(
            onSelected: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Catálogo'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            ProductoCard(
              nombre: 'Lente Oftálmico Gucci GG0027O Havana',
              imagenPath: 'assets/images/L1-1.png',
              description:
                  'Los Lentes oftálmicos Gucci GG0027O para mujer cuentan con un diseño marco completo redondo que les da un estilo muy femenino y atractivo, para que expreses tu personalidad. Fabricado con acetato color havana super resistentes y cómodos de usar para altas jornadas del día. Recomendado para rostros cuadrados y forma de diamante. Sé parte de este modelo y complementa tu look con Gucci.',
              precio: 800,
            ),
            ProductoCard(
              nombre: 'Lente Oftálmico Martha Debayle JOAN Negro',
              imagenPath: 'assets/images/L2-1.png',
              description:
                  'Los lentes oftálmicos JOAN son inspirados en Joan Crawford tienen un marco completo en forma cuadrada oversize fabricado En acetato negro. Las varillas están hechas de metal en color dorado con diseño circular garigoleado. Sus terminales son de rayas en blanco y negro. Recomendado para rostros ovalados y forma de diamante.',
              precio: 575,
            ),
            ProductoCard(
              nombre: 'Lente Oftálmico Ray Ban RB7047O Negro',
              imagenPath: 'assets/images/L3-1.png',
              description:
                  'Los Lentes Oftálmicos Ray-Ban RB7047O cuentan con un diseño rectangular que les da un estilo clásico para que expreses tu personalidad. Fabricado en acetato, este armazón es muy cómodo, resistente y duradero. El armazón Ray-Ban oftálmico viene en color negro mate que le da un toque de modernidad a lo clásico.',
              precio: 900,
            ),
            ProductoCard(
              nombre: 'Lentes de Contacto Lunare cosmético Neutro',
              imagenPath: 'assets/images/L4-1.png',
              description:
                  'Los lentes de contacto Lunare están fabricados con la tecnología Tri-Kolor, que gracias a sus tres capas de color ofrece un aspecto más natural a tus ojos y la mayor comodidad.',
              precio: 500,
            ),
            ProductoCard(
              nombre: 'Lentes de Sol Ray-Ban JA-JO',
              imagenPath: 'assets/images/L5-1.png',
              description:
                  'Usa la energía de los ojos brillantes y el ambiente jovial del mundo de los festivales con el nuevo estilo esencial veraniego - que trae el JA-JO. Hemos añadido más impacto a las atemporales gafas redondas de metal con una explosión de color para lucir un estilo elegante y contemporáneo.',
              precio: 420,
            ),
            ProductoCard(
              nombre: 'Lentes de lectura',
              imagenPath: 'assets/images/lectura.png',
              description:
                  'Lentes para lectura con estilo moderno y comodidad. Ideales para lectura diaria o en momentos específicos de trabajo o estudio.',
              precio: 150,
            ),
            ProductoCard(
              nombre: 'Lentes Rayban',
              imagenPath: 'assets/images/Rayban.png',
              description:
                  'Lentes de sol Rayban con estilo clásico y protección UV. Perfectos para cualquier ocasión bajo el sol.',
              precio: 300,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menú Lateral',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Perfil de Usuario'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(
                            usuarios,
                            onUpdateUser: _updateUser,
                          )),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu lateral',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
      ),
    );
  }
}

class ProductoCard extends StatelessWidget {
  final String nombre;
  final String imagenPath;
  final String description;
  final double precio;

  const ProductoCard({
    Key? key,
    required this.nombre,
    required this.imagenPath,
    required this.description,
    required this.precio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(
            imagenPath,
            fit: BoxFit.cover,
            height: 150,
          ),
          ListTile(
            title: Text(nombre),
            subtitle: Text('\$$precio'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleProducto(
                    nombre: nombre,
                    imagenPath: imagenPath,
                    description: description,
                    precio: precio,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetalleProducto extends StatefulWidget {
  final String nombre;
  final String imagenPath;
  final String description;
  final double precio;

  const DetalleProducto({
    Key? key,
    required this.nombre,
    required this.imagenPath,
    required this.description,
    required this.precio,
  }) : super(key: key);

  @override
  _DetalleProductoState createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  final _reviewController = TextEditingController();

  List<Review> reviews = [];

  late String nombre;
  late String description;
  late double precio;

  @override
  void initState() {
    super.initState();
    nombre = widget.nombre;
    description = widget.description;
    precio = widget.precio;
  }

  void _loadProductDetailsFromXml() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (result != null) {
      PlatformFile file = result.files.first;
      String xmlContent = utf8.decode(file.bytes!);
      var document = xml.XmlDocument.parse(xmlContent);
      setState(() {
        nombre = document.findAllElements('nombre').first.text;
        description = document.findAllElements('description').first.text;
        precio = double.parse(document.findAllElements('precio').first.text);
      });
    } else {
      // Usuario canceló la selección del archivo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagenPath,
              fit: BoxFit.cover,
              height: 150,
            ),
            SizedBox(height: 16),
            Text(
              nombre,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '\$${precio}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadProductDetailsFromXml,
              child: Text('Cargar detalles desde XML'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Escribe tu reseña',
              ),
              maxLines: null,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  reviews.add(
                    Review(
                      username: 'Usuario',
                      review: _reviewController.text,
                    ),
                  );
                  _reviewController.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Reseña agregada con éxito'),
                  duration: Duration(seconds: 2),
                ));
              },
              child: Text('Enviar Reseña'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ListTile(
                    title: Text(review.username),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.review),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Review {
  final String username;
  final String review;

  Review({
    required this.username,
    required this.review,
  });
}

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

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Simula un inicio de sesión exitoso
                },
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  void _registerOrUpdate() {
    final userData = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'password': _passwordController.text,
    };

    if (widget.userIndex != null && widget.onUpdate != null) {
      widget.onUpdate!(widget.userIndex!, userData);
    } else {
      widget.onRegister(userData);
    }
    Navigator.pop(context);
  }

  Future<void> _loadFromJson() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      PlatformFile file = result.files.first;
      String contents = String.fromCharCodes(file.bytes!);
      final jsonData = jsonDecode(contents);

      setState(() {
        _usernameController.text = jsonData['username'];
        _emailController.text = jsonData['email'];
        _phoneController.text = jsonData['phone'];
        _passwordController.text = jsonData['password'];
        _confirmPasswordController.text = jsonData['password'];
      });
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.userIndex != null ? 'Actualizar Datos' : 'Registrarse'),
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
                onPressed: _registerOrUpdate,
                child: Text(
                    widget.userIndex != null ? 'Actualizar' : 'Registrarse'),
              ),
              ElevatedButton(
                onPressed: _loadFromJson,
                child: Text('Cargar desde JSON'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
