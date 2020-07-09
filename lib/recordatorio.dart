class Recordatorio{
  int id;
  String nombre;
  String fecha;
  String hora;
  String descripcion;
  Recordatorio (this.id, this.nombre,this.fecha,this.hora,this.descripcion);
  //,this.ApellidoMaterno,this.TELEFONO,this.Correo,this.numcontrol);

  Map<String,dynamic>toMap(){
    print("este es el recordatorio");
    print("recibimos $id,$nombre,$fecha,$hora");

    var map = <String,dynamic>{
      'id': id,
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
      'descripcion':descripcion
    };
    return map;
  }
  Recordatorio.fromMap(Map<String,dynamic> map){
    id = map['id'];
    nombre = map['nombre'];
    fecha = map['fecha'];
    hora = map['hora'];
    descripcion = map['descripcion'];
  }

}

class completados{
  int id;
  String tipo;
  String nombre;
  String fecha;
  String hora;
  int num;

  String descripcion;
  completados (this.num,this.id,this.tipo, this.nombre,this.fecha,this.hora,this.descripcion);
  //,this.ApellidoMaterno,this.TELEFONO,this.Correo,this.numcontrol);

  Map<String,dynamic>toMap(){
    print("este es el recordatorio");
    print("recibimos $id,$nombre,$fecha,$hora");

    var map = <String,dynamic>{
      'num': num,
      'id': id,
      'tipo': tipo,
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
      'descripcion':descripcion
    };
    return map;
  }
  completados.fromMap(Map<String,dynamic> map){
    num = map['num'];
    id = map['id'];
    tipo = map['tipo'];
    nombre = map['nombre'];
    fecha = map['fecha'];
    hora = map['hora'];
    descripcion = map['descripcion'];
  }

}


class Recordatorio2 {
  String campo;
  int id;
  String valor;
  Recordatorio2(this.id, this.campo,this.valor);

  Map<String,dynamic>toMap2(){
    print("esto recibe students");
    var map = <String,dynamic>{
      'id': id,
      '$campo': valor
    };
    return map;
  }
  Recordatorio2.fromMap(Map<String,dynamic> map){
    id = map['id'];
    campo= map['$campo'];
  }

}
