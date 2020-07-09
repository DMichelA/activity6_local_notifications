import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'recordatorio.dart';
import 'dart:async';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'mostrarsemanaltarjeta.dart';

class actualizacionSemanal extends StatefulWidget {
  int id;
  actualizacionSemanal(this.id);
  @override
  _actualizacionSemanal createState() => new _actualizacionSemanal(this.id);
}

class _actualizacionSemanal extends State<actualizacionSemanal> {
  //VARIABLES REFERENTES AL MANEJO DE LA BD
  int id;
  _actualizacionSemanal(this.id);
  Future<List<Recordatorio>> recordatorios;
  int contador;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  String nombre;
  String hora;
  String fecha;
  int currentUserId;
  bool deshabilitar;
  bool deshabilitar2;
  bool deshabilitar3;
  String descripcion;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  String imagen;
  String imagen2;
  List<Map> listarec;
  int dia;
  List<Map> decodificarDiario;
  List<Map> decodificarSemanal;
  List<Map> decodificarProgramado;
  List almacendiario = List<dynamic>();
  List almacensemanal = List<dynamic>();
  List almacenprogramado = List<dynamic>();

  //

  //PARA SABER ESTADO ACTUAL DE LA CONSULTA

  @override
  void initState() {
    super.initState();
    deshabilitar = false;
    deshabilitar2 = false;
    deshabilitar3 = false;

    dbHelper = DBHelper();
    isUpdating = false;
  }

  void analisisDatos() async {
    decodificarDiario = await dbHelper.decodificar();
    decodificarSemanal = await dbHelper.decodificar2();
    decodificarProgramado = await dbHelper.decodificar3();
    int longdiario = decodificarDiario.length;
    int longsemanal = decodificarSemanal.length;
    int longprogramado = decodificarProgramado.length;
    var anioactual = DateTime.now().year;
    var mesactual = DateTime.now().month;
    var diaactual = DateTime.now().day;
    var horasactuales = DateTime.now().hour;
    var minactual = DateTime.now().minute;
    var segactual = DateTime.now().second;

    for (int i = 0; i < longdiario; i++) {
      var anio = int.parse((decodificarDiario[i]["fecha"]).substring(0, 4));
      var mes = int.parse((decodificarDiario[i]["fecha"]).substring(5, 7));
      var dia = int.parse((decodificarDiario[i]["fecha"]).substring(8, 10));
      var hora = int.parse((decodificarDiario[i]["hora"]).substring(0, 2));
      var minutos = int.parse((decodificarDiario[i]["hora"]).substring(3, 5));
      var segundos = int.parse((decodificarDiario[i]["hora"]).substring(6, 8));
      var nombre = decodificarDiario[i]["nombre"];
      var descripcion = decodificarDiario[i]["descripcion"];
      var horacompleta = decodificarDiario[i]["hora"];
      var diaConcatenar = dia + 1;
      var diaConcatenarcomplete;
      if (diaConcatenar > 0 && diaConcatenar < 10) {
        diaConcatenarcomplete = "0" + diaConcatenar.toString();
      } else {
        diaConcatenarcomplete = diaConcatenar.toString();
      }
      var fechacompleta = anio.toString() +
          "-" +
          (decodificarDiario[i]["fecha"]).substring(5, 7) +
          "-" +
          diaConcatenarcomplete;
      if (anio < anioactual) {
        print("ya paso el evento año");
        almacendiario.add(decodificarDiario[i]["id"]);
        completados complete = completados(
            null,
            decodificarDiario[i]["id"],
            "Diario",
            decodificarDiario[i]["nombre"],
            decodificarDiario[i]["fecha"],
            decodificarDiario[i]["hora"],
            decodificarDiario[i]["descripcion"]);
        dbHelper.insert4(complete);
        Recordatorio rec = Recordatorio(
            null, nombre, fechacompleta, horacompleta, descripcion);
        dbHelper.insert(rec);
      } else if (anio == anioactual) {
        print("el añño es el misp");
        if (mes < mesactual) {
          print("ya paso el evento mes");
          almacendiario.add(decodificarDiario[i]["id"]);
          completados complete = completados(
              null,
              decodificarDiario[i]["id"],
              "Diario",
              decodificarDiario[i]["nombre"],
              decodificarDiario[i]["fecha"],
              decodificarDiario[i]["hora"],
              decodificarDiario[i]["descripcion"]);
          dbHelper.insert4(complete);
          Recordatorio rec = Recordatorio(
              null, nombre, fechacompleta, horacompleta, descripcion);
          dbHelper.insert(rec);
        } else if (mes == mesactual) {
          print("mismo mes");
          if (dia < diaactual) {
            print("el evento paso dia");
            almacendiario.add(decodificarDiario[i]["id"]);
            completados complete = completados(
                null,
                decodificarDiario[i]["id"],
                "Diario",
                decodificarDiario[i]["nombre"],
                decodificarDiario[i]["fecha"],
                decodificarDiario[i]["hora"],
                decodificarDiario[i]["descripcion"]);
            dbHelper.insert4(complete);
            Recordatorio rec = Recordatorio(
                null, nombre, fechacompleta, horacompleta, descripcion);
            dbHelper.insert(rec);
          } else if (dia == diaactual) {
            print("mismo dia");
            if (hora < horasactuales) {
              print("el evento ya paso horas");
              almacendiario.add(decodificarDiario[i]["id"]);
              completados complete = completados(
                  null,
                  decodificarDiario[i]["id"],
                  "Diario",
                  decodificarDiario[i]["nombre"],
                  decodificarDiario[i]["fecha"],
                  decodificarDiario[i]["hora"],
                  decodificarDiario[i]["descripcion"]);
              dbHelper.insert4(complete);
              Recordatorio rec = Recordatorio(
                  null, nombre, fechacompleta, horacompleta, descripcion);
              dbHelper.insert(rec);
            } else if (hora == horasactuales) {
              print("horas actuales");
              if (minutos < minactual) {
                print("el evento ya paso minutos");
                almacendiario.add(decodificarDiario[i]["id"]);
                completados complete = completados(
                    null,
                    decodificarDiario[i]["id"],
                    "Diario",
                    decodificarDiario[i]["nombre"],
                    decodificarDiario[i]["fecha"],
                    decodificarDiario[i]["hora"],
                    decodificarDiario[i]["descripcion"]);
                dbHelper.insert4(complete); //agregar a completados
                Recordatorio rec = Recordatorio(
                    null, nombre, fechacompleta, horacompleta, descripcion);
                dbHelper.insert(rec);
              } else if (minutos == minactual) {
                if (segundos < segactual) {
                  print("el evento ya paso segudnoss");
                  almacendiario.add(decodificarDiario[i]["id"]);
                  completados complete = completados(
                      null,
                      decodificarDiario[i]["id"],
                      "Diario",
                      decodificarDiario[i]["nombre"],
                      decodificarDiario[i]["fecha"],
                      decodificarDiario[i]["hora"],
                      decodificarDiario[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec = Recordatorio(
                      null, nombre, fechacompleta, horacompleta, descripcion);
                  dbHelper.insert(rec);
                } else if (segundos == segactual) {
                  print("el evento llego");
                  almacendiario.add(decodificarDiario[i]["id"]);
                  completados complete = completados(
                      null,
                      decodificarDiario[i]["id"],
                      "Diario",
                      decodificarDiario[i]["nombre"],
                      decodificarDiario[i]["fecha"],
                      decodificarDiario[i]["hora"],
                      decodificarDiario[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec = Recordatorio(
                      null, nombre, fechacompleta, horacompleta, descripcion);
                  dbHelper.insert(rec);
                }
              }
            }
          }
        }
      }
    }
    int longalmacendiario = almacendiario.length;
    print(longalmacendiario);
    for (int i = 0; i < longalmacendiario; i++) {
      print(almacendiario[i]);
      dbHelper.delete(almacendiario[i]);
    }

    for (int i = 0; i < longsemanal; i++) {
      var anio = int.parse((decodificarSemanal[i]["fecha"]).substring(0, 4));
      var mes = int.parse((decodificarSemanal[i]["fecha"]).substring(5, 7));
      var dia = int.parse((decodificarSemanal[i]["fecha"]).substring(8, 10));
      var hora = int.parse((decodificarSemanal[i]["hora"]).substring(0, 2));
      var minutos = int.parse((decodificarSemanal[i]["hora"]).substring(3, 5));
      var segundos = int.parse((decodificarSemanal[i]["hora"]).substring(6, 8));
      var nombre = decodificarSemanal[i]["nombre"];
      var descripcion = decodificarSemanal[i]["descripcion"];
      var horacompleta = decodificarSemanal[i]["hora"];
      int dianuevo;
      int mesnuevo;
      int anionuevo;
      String dianuevocadena;
      String mesnuevocadena;
      if (mes == 1 ||
          mes == 3 ||
          mes == 5 ||
          mes == 7 ||
          mes == 8 ||
          mes == 10 ||
          mes == 12) {
        dianuevo = dia + 7;
        mesnuevo = mes;
        anionuevo = anio;
        if (dianuevo > 31) {
          dianuevo -= 31;
          mesnuevo = mes + 1;
          if (mesnuevo > 12) {
            mesnuevo -= 12;
            anionuevo = anio + 1;
          }
        }
      } else if (mes == 2) {
        dianuevo = dia + 7;
        if (dianuevo > 28) {
          dianuevo -= 28;
          mesnuevo = mes + 1;
        }
      } else if (mes == 4 || mes == 6 || mes == 9 || mes == 11) {
        dianuevo = dia + 1;
        if (dianuevo > 30) {
          dianuevo -= 30;
          mes += 1;
        }
      }

      if (dianuevo > 0 && dianuevo < 10) {
        dianuevocadena = "0" + dianuevo.toString();
      } else {
        dianuevocadena = dianuevo.toString();
      }

      if (mesnuevo > 0 && mesnuevo < 10) {
        mesnuevocadena = "0" + mesnuevo.toString();
      } else {
        mesnuevocadena = mesnuevo.toString();
      }
      var fechacompleta =
          anionuevo.toString() + "-" + mesnuevocadena + "-" + dianuevocadena;

      if (anio < anioactual) {
        print("ya paso el evento año");
        almacensemanal.add(decodificarSemanal[i]["id"]);
        completados complete = completados(
            null,
            decodificarSemanal[i]["id"],
            "Semanal",
            decodificarSemanal[i]["nombre"],
            decodificarSemanal[i]["fecha"],
            decodificarSemanal[i]["hora"],
            decodificarSemanal[i]["descripcion"]);
        dbHelper.insert4(complete);
        Recordatorio rec = Recordatorio(
            null, nombre, fechacompleta, horacompleta, descripcion);
        dbHelper.insert2(rec);
      } else if (anio == anioactual) {
        print("el añño es el misp");
        if (mes < mesactual) {
          print("ya paso el evento mes");
          almacensemanal.add(decodificarSemanal[i]["id"]);
          completados complete = completados(
              null,
              decodificarSemanal[i]["id"],
              "Semanal",
              decodificarSemanal[i]["nombre"],
              decodificarSemanal[i]["fecha"],
              decodificarSemanal[i]["hora"],
              decodificarSemanal[i]["descripcion"]);
          dbHelper.insert4(complete);
          Recordatorio rec = Recordatorio(
              null, nombre, fechacompleta, horacompleta, descripcion);
          dbHelper.insert2(rec);
        } else if (mes == mesactual) {
          print("mismo mes");
          if (dia < diaactual) {
            print("el evento paso dia");
            almacensemanal.add(decodificarSemanal[i]["id"]);
            completados complete = completados(
                null,
                decodificarSemanal[i]["id"],
                "Semanal",
                decodificarSemanal[i]["nombre"],
                decodificarSemanal[i]["fecha"],
                decodificarSemanal[i]["hora"],
                decodificarSemanal[i]["descripcion"]);
            dbHelper.insert4(complete);
            Recordatorio rec = Recordatorio(
                null, nombre, fechacompleta, horacompleta, descripcion);
            dbHelper.insert2(rec);
          } else if (dia == diaactual) {
            print("mismo dia");
            if (hora < horasactuales) {
              print("el evento ya paso horas");
              almacensemanal.add(decodificarSemanal[i]["id"]);
              completados complete = completados(
                  null,
                  decodificarSemanal[i]["id"],
                  "Semanal",
                  decodificarSemanal[i]["nombre"],
                  decodificarSemanal[i]["fecha"],
                  decodificarSemanal[i]["hora"],
                  decodificarSemanal[i]["descripcion"]);
              dbHelper.insert4(complete);
              Recordatorio rec = Recordatorio(
                  null, nombre, fechacompleta, horacompleta, descripcion);
              dbHelper.insert2(rec);
            } else if (hora == horasactuales) {
              print("horas actuales");
              if (minutos < minactual) {
                print("el evento ya paso minutos");
                almacensemanal.add(decodificarSemanal[i]["id"]);
                completados complete = completados(
                    null,
                    decodificarSemanal[i]["id"],
                    "Semanal",
                    decodificarSemanal[i]["nombre"],
                    decodificarSemanal[i]["fecha"],
                    decodificarSemanal[i]["hora"],
                    decodificarSemanal[i]["descripcion"]);
                dbHelper.insert4(complete);
                Recordatorio rec = Recordatorio(
                    null, nombre, fechacompleta, horacompleta, descripcion);
                dbHelper.insert2(rec);
              } else if (minutos == minactual) {
                if (segundos < segactual) {
                  print("el evento ya paso segudnoss");
                  almacensemanal.add(decodificarSemanal[i]["id"]);
                  completados complete = completados(
                      null,
                      decodificarSemanal[i]["id"],
                      "Semanal",
                      decodificarSemanal[i]["nombre"],
                      decodificarSemanal[i]["fecha"],
                      decodificarSemanal[i]["hora"],
                      decodificarSemanal[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec = Recordatorio(
                      null, nombre, fechacompleta, horacompleta, descripcion);
                  dbHelper.insert2(rec);
                } else if (segundos == segactual) {
                  print("el evento llego");
                  almacensemanal.add(decodificarSemanal[i]["id"]);
                  completados complete = completados(
                      null,
                      decodificarSemanal[i]["id"],
                      "Semanal",
                      decodificarSemanal[i]["nombre"],
                      decodificarSemanal[i]["fecha"],
                      decodificarSemanal[i]["hora"],
                      decodificarSemanal[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec = Recordatorio(
                      null, nombre, fechacompleta, horacompleta, descripcion);
                  dbHelper.insert2(rec);
                }
              }
            }
          }
        }
      }
    }

    int longalmacensemanal = almacensemanal.length;
    for (int i = 0; i < longalmacensemanal; i++) {
      print(almacensemanal[i]);
      dbHelper.delete2(almacensemanal[i]);
    }

    for (int i = 0; i < longprogramado; i++) {
      var anio = int.parse((decodificarProgramado[i]["fecha"]).substring(0, 4));
      var mes = int.parse((decodificarProgramado[i]["fecha"]).substring(5, 7));
      var dia = int.parse((decodificarProgramado[i]["fecha"]).substring(8, 10));
      var hora = int.parse((decodificarProgramado[i]["hora"]).substring(0, 2));
      var minutos =
          int.parse((decodificarProgramado[i]["hora"]).substring(3, 5));
      var segundos =
          int.parse((decodificarProgramado[i]["hora"]).substring(6, 8));
      if (anio < anioactual) {
        print("ya paso el evento año");
        almacenprogramado.add(decodificarProgramado[i]["id"]);
        completados complete = completados(
            null,
            decodificarProgramado[i]["id"],
            "Programado",
            decodificarProgramado[i]["nombre"],
            decodificarProgramado[i]["fecha"],
            decodificarProgramado[i]["hora"],
            decodificarProgramado[i]["descripcion"]);
        dbHelper.insert4(complete);
      } else if (anio == anioactual) {
        print("el añño es el misp");
        if (mes < mesactual) {
          print("ya paso el evento mes");
          almacenprogramado.add(decodificarProgramado[i]["id"]);
          completados complete = completados(
              null,
              decodificarProgramado[i]["id"],
              "Programado",
              decodificarProgramado[i]["nombre"],
              decodificarProgramado[i]["fecha"],
              decodificarProgramado[i]["hora"],
              decodificarProgramado[i]["descripcion"]);
          dbHelper.insert4(complete);
        } else if (mes == mesactual) {
          print("mismo mes");
          if (dia < diaactual) {
            print("el evento paso dia");
            almacenprogramado.add(decodificarProgramado[i]["id"]);
            completados complete = completados(
                null,
                decodificarProgramado[i]["id"],
                "Programado",
                decodificarProgramado[i]["nombre"],
                decodificarProgramado[i]["fecha"],
                decodificarProgramado[i]["hora"],
                decodificarProgramado[i]["descripcion"]);
            dbHelper.insert4(complete);
          } else if (dia == diaactual) {
            print("mismo dia");
            if (hora < horasactuales) {
              print("el evento ya paso horas");
              almacenprogramado.add(decodificarProgramado[i]["id"]);
              completados complete = completados(
                  null,
                  decodificarProgramado[i]["id"],
                  "Programado",
                  decodificarProgramado[i]["nombre"],
                  decodificarProgramado[i]["fecha"],
                  decodificarProgramado[i]["hora"],
                  decodificarProgramado[i]["descripcion"]);
              dbHelper.insert4(complete);
            } else if (hora == horasactuales) {
              print("horas actuales");
              if (minutos < minactual) {
                print("el evento ya paso minutos");
                almacenprogramado.add(decodificarProgramado[i]["id"]);
                completados complete = completados(
                    null,
                    decodificarProgramado[i]["id"],
                    "Programado",
                    decodificarProgramado[i]["nombre"],
                    decodificarProgramado[i]["fecha"],
                    decodificarProgramado[i]["hora"],
                    decodificarProgramado[i]["descripcion"]);
                dbHelper.insert4(complete);
              } else if (minutos == minactual) {
                if (segundos < segactual) {
                  print("el evento ya paso segudnoss");
                  almacenprogramado.add(decodificarProgramado[i]["id"]);
                  completados complete = completados(
                      null,
                      decodificarProgramado[i]["id"],
                      "Programado",
                      decodificarProgramado[i]["nombre"],
                      decodificarProgramado[i]["fecha"],
                      decodificarProgramado[i]["hora"],
                      decodificarProgramado[i]["descripcion"]);
                  dbHelper.insert4(complete);
                } else if (segundos == segactual) {
                  print("el evento llego");
                  almacenprogramado.add(decodificarProgramado[i]["id"]);
                  completados complete = completados(
                      null,
                      decodificarProgramado[i]["id"],
                      "Programado",
                      decodificarProgramado[i]["nombre"],
                      decodificarProgramado[i]["fecha"],
                      decodificarProgramado[i]["hora"],
                      decodificarProgramado[i]["descripcion"]);
                  dbHelper.insert4(complete);
                }
              }
            }
          }
        }
      }
      int longalmacenprogramado = almacenprogramado.length;
      for (int i = 0; i < longalmacenprogramado; i++) {
        dbHelper.delete3(almacenprogramado[i]);
      }
    }
  }

  void enviaraclase() async {
    listarec = await dbHelper.decodificar2();
    int longitud = listarec.length;
    print("hay $longitud elementos");
    int idn = listarec[listarec.length - 1]["id"];
    String nombren = listarec[listarec.length - 1]["nombre"];
    String fechan = listarec[listarec.length - 1]["fecha"];
    String horan = listarec[listarec.length - 1]["hora"];
    print(horan);
    if (dia != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  mostrarNotificacion(idn, nombren, fechan, horan, dia)));
    }

    setState(() {
      fecha = "";
      hora = "";
      nombre = "";
      descripcion = "";
    });
  }

  void quitar() {}

  void cleanData() {
    controller.text = "";
    controller2.text = "";
    controller3.text = "";

    deshabilitar = false;
    deshabilitar2 = false;
    deshabilitar3 = false;
  }

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  _showSnackbar(BuildContext context, String texto) {
    final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: 'Schyler',
              fontWeight: FontWeight.bold,
            )));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  //FORMULARIO
  Widget form() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: new SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  new SizedBox(height: 50.0),
                  TextFormField(
                    enabled: deshabilitar ? false : true,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Nombre del recordatorio",
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        //No desaparece el borde
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                    validator: (val) =>
                        val.length == 0 ? 'Ingresa un recordatorio' : null,
                    onSaved: (val) => nombre = controller.text,
                  ),
                  new SizedBox(height: 20),
                  TextFormField(
                    enabled: deshabilitar ? false : true,
                    controller: controller2,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Descripcion del recordatorio",
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        //No desaparece el borde
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                    onSaved: (val) => descripcion = controller2.text,
                  ),
                  FlatButton.icon(
                      onPressed: () {
                        var horas;
                        var minutos;
                        var segundos;
                        var meses;
                        var dias;
                        DatePicker.showPicker(context, showTitleActions: true,
                            onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          print('confirm $date');
                          int hor = date.hour;
                          int minuto = date.minute;
                          int segundo = date.second;
                          int anio = date.year;
                          int mes = date.month;
                          int dia = date.day;
                          if (hor < 10) {
                            horas = "0" + hor.toString();
                          } else {
                            horas = hor.toString();
                          }

                          if (minuto < 10) {
                            minutos = "0" + minuto.toString();
                          } else {
                            minutos = minuto.toString();
                          }

                          if (segundo < 10) {
                            segundos = "0" + segundo.toString();
                          } else {
                            segundos = segundo.toString();
                          }

                          if (mes < 10) {
                            meses = "0" + mes.toString();
                          } else {
                            meses = mes.toString();
                          }

                          if (dia < 10) {
                            dias = "0" + dia.toString();
                          } else {
                            dias = dia.toString();
                          }

                          fecha = anio.toString() + "-" + meses + "-" + dias;
                          hora = horas + ":" + minutos + ":" + segundos;
                          print(fecha);
                          print(hora);
                        },
                            pickerModel:
                                CustomPicker(currentTime: DateTime.now()),
                            locale: LocaleType.es);
                      },
                      icon: Icon(Icons.watch_later, color: Colors.redAccent),
                      label: Text(
                        'Selecciona hora del evento semanalmente',
                        style: TextStyle(color: Colors.lightBlue),
                      )),
                  FlatButton.icon(
                      icon: Icon(Icons.today, color: Colors.redAccent),
                      label: Text('Selecciona dia del evento',
                          style: TextStyle(color: Colors.lightBlue)),
                      onPressed: _optionsdays),
                  SizedBox(height: 30),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: insert,
                        //SI ESTA LLENO ACTUALIZAR, SI NO AGREGAR
                        color: Colors.lightBlue,
                        child: Text(
                          'Actualizar Recordatorio',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
//                  MaterialButton(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(18.0),
//                      side: BorderSide(color: Colors.blue[800]),
//                    ),
//                    onPressed: () {
//                      setState(() {
//                        isUpdating = false;
//                        deshabilitar = false;
//                        deshabilitar2 = false;
//                        deshabilitar3 = false;
//                      });
//                      cleanData();
//                    },
//                    child: Text("Cancel"),
//                  ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _optionsdays() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Lunes'),
                    onTap: () {
                      dia = 1;
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Martes'),
                      onTap: () {
                        dia = 2;
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Miercoles'),
                      onTap: () {
                        dia = 3;
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Jueves'),
                      onTap: () {
                        dia = 4;
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Viernes'),
                      onTap: () {
                        dia = 5;
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Sabado'),
                      onTap: () {
                        dia = 6;
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Domingo'),
                      onTap: () {
                        dia = 7;
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldkey,
      appBar: new AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text("Actualizar Recordatorio",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Container(width: 100, height: 30),
            ),
          ),
          new Center(
            child: Container(
              height: 150,
              width: 150,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    image: new NetworkImage(
                        "https://i7.pngguru.com/preview/611/697/300/emergency-notification-system-push-technology-email-message-alarm.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                form(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void insert() {
    print("enrando a insert");
    if (isUpdating == false) {
      nombre = controller.text;

      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        Recordatorio rec =
            Recordatorio(null, nombre.toUpperCase(), fecha, hora, descripcion);
        if (nombre == null ||
            nombre == "" ||
            fecha == "" ||
            fecha == null ||
            hora == "" ||
            fecha == null) {
          _showSnackbar(context, "no se inserto");
        } else {
          dbHelper.update2(rec);
          fecha = "";
          hora = "";
          cleanData();
          print("hast aqui vamos bien");
          enviaraclase();
        }
      }
    }

//  pickImagefromGallery() {
//    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
//      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
//
//      imagen = imgString;
//      controllerimagen.text = "lleno";
//      return imagen;
//    });
//  }
//
//  pickImagefromCamera() {
//    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
//      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
//      imagen = imgString;
//      controllerimagen.text = "lleno";
//      return imagen;
//    });
//  }

//  Future<void> _optionsDialogBox() {
//    return showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            content: SingleChildScrollView(
//              child: ListBody(
//                children: <Widget>[
//                  GestureDetector(
//                    child: Text('Tomar foto'),
//                    onTap: pickImagefromCamera,
//                  ),
//
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                  ),
//                  GestureDetector(
//                    child: Text('Subir foto'),
//                    onTap: pickImagefromGallery,
//                  ),
//                ],
//              ),
//            ),
//          );
//        });
//  }
  }
}

class mostrarNotificacion extends StatefulWidget {
  mostrarNotificacion(this.id, this.nombre, this.fecha, this.hora, this.dia);

  int id;
  String nombre;
  String fecha;
  String hora;
  int dia;

  @override
  _mostrarNotificacionState createState() => _mostrarNotificacionState(
      this.id, this.nombre, this.fecha, this.hora, this.dia);
}

class _mostrarNotificacionState extends State<mostrarNotificacion> {
  _mostrarNotificacionState(
      this.id, this.nombre, this.fecha, this.hora, this.dia);

  int id;
  String nombre;
  String fecha;
  String hora;
  int dia;

  @override
  void initState() {
    super.initState();
    _showNotification();
    print("llego");
    print(dia);
  }

  //////metodos de notif
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIos;
  var initializationSettings;

  void _showNotification() async {
    await _simpleScheduleNotification();
  }

  Future<void> _simpleScheduleNotification() async {
    var IOSPlatformChannelSpecifics = IOSNotificationDetails();
    var now = new DateTime.now();
    //notificacion a los 3 minutos
//    var reprogram = now.add(Duration(hours: 00, minutes: 00, seconds: 10));
    var times = DateTime.parse(fecha + "T" + hora + ".000");
    int horas = times.hour;
    int minutos = times.minute;
    int segundos = times.second;
    Day dias = Day(dia);
    var time = Time(horas, minutos, segundos);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id,
        nombre,
        hora,
        dia == 1
            ? Day.Monday
            : dia == 2
                ? Day.Tuesday
                : dia == 3
                    ? Day.Wednesday
                    : dia == 4
                        ? Day.Thursday
                        : dia == 5
                            ? Day.Friday
                            : dia == 6 ? Day.Saturday : Day.Sunday,
        time,
        platformChannelSpecifics);
    print("la notif con id:" + id.toString() + "es" + times.toString());
    //id aleatorio tiene que ser pero por ahora estatico

    ///ver la hora programada
    Fluttertoast.showToast(
        msg: 'Scheduled on day ' +
            (dia == 1
                ? "Monday"
                : dia == 2
                    ? "Tuesday"
                    : dia == 3
                        ? "Wednesday"
                        : dia == 4
                            ? "Thursday"
                            : dia == 5
                                ? "Friday"
                                : dia == 6 ? "Saturday" : "Sunday"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return mostrarTarjetaSemanal();
  }


}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
