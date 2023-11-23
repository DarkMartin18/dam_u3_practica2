import 'package:dam_u3_practica2/serviciosremotos.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("U3 - Práctica 2"),
        centerTitle: true,
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(child: Text("MB"),),
                SizedBox(height: 20,),
                Text("Martin Barrón", style: TextStyle(color: Colors.white, fontSize: 20),)
              ],
            ),
              decoration: BoxDecoration(color: Colors.teal),
            ),
            SizedBox(height: 20,),
            _item(Icons.add, "Registrar", 1),
            _item(Icons.format_list_bulleted, "Lista", 0),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [Expanded(child: Icon(icono)), Expanded(child: Text(texto),flex: 2,)],
      ),
    );
  }

  Widget dinamico(){
    if(_index==1){
      return registrar();
    }
    return cargarData();
  }

  Widget registrar(){
    final nombre = TextEditingController();
    String tipo = "";
    final duracion = TextEditingController();
    final calorias = TextEditingController();

    return SingleChildScrollView(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombre,
            decoration: InputDecoration(
                labelText: "Nombre del ejercicio"
            ),
          ),
          SizedBox(height: 20,),
          Text("Tipo de ejercicio", style: TextStyle(color: Colors.black54, fontSize: 16),),
          SizedBox(height: 10,),
          DropdownMenu<String>(
            initialSelection: tipo,
            onSelected: (String? value) {
              tipo = value!;
            },
            dropdownMenuEntries: <String>[
              'Aeróbico',
              'Anaeróbico',
              'Flexibilidad',
              'Equilibrio y estabilidad',
            ].map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
          TextField(
            controller: duracion,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Duración (minutos)"
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: calorias,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Calorías estimadas"
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: (){
                    var JSonTemporal = {
                      "nombreEjercicio": nombre.text,
                      "tipo": tipo,
                      "duracion": int.parse(duracion.text),
                      "caloriasEstimadas": int.parse(calorias.text),
                    };
                    DB.insertar(JSonTemporal).then((value) {
                      setState(() {
                        tipo = "";
                      });
                    });
                  },
                  child: Text("Insertar")
              ),
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      _index = 0;
                    });
                  },
                  child: Text("Cancel")
              ),
            ],
          )
        ],
      ),
    );
  }

  void actualizar(Map<String, dynamic> ejercicio, int ind, VoidCallback onActualizado){
    final nombre = TextEditingController();
    String tipo = "";
    final duracion = TextEditingController();
    final calorias = TextEditingController();
    nombre.text = ejercicio["nombreEjercicio"];
    tipo = ejercicio["tipo"];
    duracion.text = ejercicio["duracion"].toString();
    calorias.text = ejercicio["caloriasEstimadas"].toString();
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 5,
        context: context,
        builder: (builder){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return
                  Container(
                    padding: EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nombre,
                          decoration: InputDecoration(
                              labelText: "Nombre del ejercicio"
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text("Tipo de ejercicio", style: TextStyle(color: Colors.black54, fontSize: 16),),
                        SizedBox(height: 10,),
                        DropdownMenu<String>(
                          initialSelection: tipo,
                          onSelected: (String? value) {
                            tipo = value!;
                          },
                          dropdownMenuEntries: <String>[
                            'Aeróbico',
                            'Anaeróbico',
                            'Flexibilidad',
                            'Equilibrio y estabilidad',
                          ].map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value);
                          }).toList(),
                        ),
                        TextField(
                          controller: duracion,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Duración (minutos)"
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: calorias,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Calorías estimadas"
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: (){
                                  var JSonTemporal = {
                                    ...ejercicio,
                                    "nombreEjercicio": nombre.text,
                                    "tipo": tipo,
                                    "duracion": int.parse(duracion.text),
                                    "caloriasEstimadas": int.parse(calorias.text),
                                  };
                                  DB.actualizar(JSonTemporal).then((value) {
                                    setState(() {
                                      tipo = "";
                                    });
                                  });
                                  onActualizado();
                                  Navigator.pop(context);
                                },
                                child: Text("Insertar")
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    _index = 0;
                                  });
                                  onActualizado();
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")
                            ),
                          ],
                        )
                      ],
                    ),
                  );
              }
          );
        }
    );
  }

  Widget cargarData(){
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON) {
          if(listaJSON.hasData){
            return ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context, indice) {
                  return ListTile(
                    title: Text("${listaJSON.data?[indice]["nombreEjercicio"]}"),
                    subtitle: Text("${listaJSON.data?[indice]["tipo"]}"),
                    trailing: IconButton(
                        onPressed: (){
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (builder){
                                  return AlertDialog(
                                    title: Text("Advertencia"),
                                    content: Text("¿Estás seguro de eliminar este ejercicio?"),
                                    actions: [
                                      TextButton(onPressed: (){
                                        setState(() {
                                          DB.eliminar(listaJSON.data?[indice]["id"]).then((value) => setState(() {}));
                                          Navigator.pop(context);
                                        });
                                      },
                                          child: Text("Eliminar")),
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancelar")),
                                    ],
                                  );
                                }
                            );
                          });
                          },
                        icon: Icon(Icons.delete)
                    ),
                    onTap: () {
                      actualizar(listaJSON.data?[indice], indice, () => setState((){}));
                    },
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }
}
