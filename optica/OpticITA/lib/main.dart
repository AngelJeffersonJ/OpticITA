import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
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
                MaterialPageRoute(builder: (context) => RegisterScreen()),
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
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('Opción 2'),
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
              description: 'Los Lentes oftálmicos Gucci GG0027O para mujer cuentan con un diseño marco completo redondo que les da un estilo muy femenino y atractivo, para que expreses tu personalidad. Fabricado con acetato color havana super resistentes y cómodos de usar para altas jornadas del día. Recomendado para rostros cuadrados y forma de diamante. Sé parte de este modelo y complementa tu look con Gucci.',
              precio: 800,
            ),
            ProductoCard(
              nombre: 'Lente Oftálmico Martha Debayle JOAN Negro',
              imagenPath: 'assets/images/L2-1.png',
              description: 'Los lentes oftálmicos JOAN son inspirados en Joan Crawford tienen un marco completo en forma cuadrada oversize fabricado En acetato negro. Las varillas están hechas de metal en color dorado con diseño circular garigoleado. Sus terminales son de rayas en blanco y negro. Recomendado para rostros ovalados y forma de diamante.',
              precio: 575,
            ),
            ProductoCard(
              nombre: 'Lente Oftálmico Ray Ban RB7047O Negro',
              imagenPath: 'assets/images/L3-1.png',
              description: 'Los Lentes Oftálmicos Ray-Ban RB7047O cuentan con un diseño rectangular que les da un estilo clásico para que expreses tu personalidad. Fabricado en acetato, este armazón es muy cómodo, resistente y duradero. El armazón Ray-Ban oftálmico viene en color negro mate que le da un toque de modernidad a lo clásico.',
              precio: 900,
            ),
            ProductoCard(
              nombre: 'Lentes de Contacto Lunare cosmético Neutro',
              imagenPath: 'assets/images/L4-1.png',
              description: 'Los lentes de contacto Lunare están fabricados con la tecnología Tri-Kolor, que gracias a sus tres capas de color ofrece un aspecto más natural a tus ojos y la mayor comodidad.',
              precio: 500,
            ),
            ProductoCard(
              nombre: 'Lentes de Sol Ray-Ban JA-JO',
              imagenPath: 'assets/images/L5-1.png',
              description: 'Usa la energía de los ojos brillantes y el ambiente jovial del mundo de los festivales con el nuevo estilo esencial veraniego - que trae el JA-JO. Hemos añadido más impacto a las atemporales gafas redondas de metal con una explosión de color para lucir un estilo elegante y contemporáneo.',
              precio: 420,
            ),
            ProductoCard(
              nombre: 'Lentes de lectura',
              imagenPath: 'assets/images/lectura.png',
              description: 'Usa la energía de los ojos brillantes y el ambiente jovial del mundo de los festivales con el nuevo estilo esencial veraniego - que trae el JA-JO. Hemos añadido más impacto a las atemporales gafas redondas de metal con una explosión de color para lucir un estilo elegante y contemporáneo.',
              precio: 420,
            ),
            ProductoCard(
              nombre: 'Lentes Rayban',
              imagenPath: 'assets/images/Rayban.png',
              description: 'Usa la energía de los ojos brillantes y el ambiente jovial del mundo de los festivales con el nuevo estilo esencial veraniego - que trae el JA-JO. Hemos añadido más impacto a las atemporales gafas redondas de metal con una explosión de color para lucir un estilo elegante y contemporáneo.',
              precio: 420,
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
              title: Text('Opción 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Opción 2'),
              onTap: () {
                Navigator.pop(context);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.search),
        backgroundColor: Colors.blue,
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

class DetalleProducto extends StatelessWidget {
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
            // Imagen
            Image.asset(
              imagenPath,
              fit: BoxFit.cover,
              height: 150, // Ajusta esta altura según tu preferencia
            ),
            SizedBox(height: 20),
            // Nombre del producto
            Text(
              nombre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Descripción
            Text(
              description,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Precio
            Text(
              '\$$precio',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            // Botón
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Producto agregado al carrito'),
                  duration: Duration(seconds: 2),
                ));
              },
              child: Text('Agregar al Carrito'),
            ),
          ],
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
                  // Implementar lógica de autenticación
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

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  icon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              
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
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implementar lógica de registro
                  Navigator.pop(context); // Simula un registro exitoso
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

