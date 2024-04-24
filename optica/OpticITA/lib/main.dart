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
              nombre: 'Lentes de Sol Ray-Ban',
              imagenPath: 'assets/images/rayban.png',
              precio: 150,
            ),
            ProductoCard(
              nombre: 'Lentes de Lectura',
              imagenPath: 'assets/images/lectura.png',
              precio: 80,
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
  final double precio;

  const ProductoCard({
    Key? key,
    required this.nombre,
    required this.imagenPath,
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
  final double precio;

  const DetalleProducto({
    Key? key,
    required this.nombre,
    required this.imagenPath,
    required this.precio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Producto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagenPath,
              fit: BoxFit.cover,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              nombre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$$precio',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
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
