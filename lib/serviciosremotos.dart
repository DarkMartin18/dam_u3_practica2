import 'package:cloud_firestore/cloud_firestore.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String, dynamic> ejercicio) async {
    return await baseRemota.collection("ejercicio").add(ejercicio);
  }

  static Future<List> mostrarTodos() async{
    List temporal = [];
    var query = await baseRemota.collection("ejercicio").get();

    query.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      data.addAll({
        'id': element.id
      });
      temporal.add(data);
    });
    return temporal;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("ejercicio").doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> ejercicio) async{
    String id = ejercicio['id'];
    ejercicio.remove(id);
    return await baseRemota.collection("ejercicio").doc(id).update(ejercicio);
  }
}