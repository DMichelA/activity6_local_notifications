import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'recordatorio.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'actualizacionprogramado.dart';

class mostrarTarjetaProgramado extends StatefulWidget {

  @override
  _mostrarTarjetaProgramado createState() => new _mostrarTarjetaProgramado();
}

class _mostrarTarjetaProgramado extends State<mostrarTarjetaProgramado> {
  //VARIABLES REFERENTES AL MANEJO DE LA BD

  Future<List<Recordatorio>> recordatorios;
  List matricula;
  int contador;
  TextEditingController controller = TextEditingController();
  int currentUserId;
  bool result;
  bool _typing = false;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  List<Map> decodificarDiario;
  List<Map> decodificarSemanal;
  List<Map> decodificarProgramado;
  List almacendiario=List<dynamic>();
  List almacensemanal=List<dynamic>();
  List almacenprogramado=List<dynamic>();

  var enviar;



  //PARA SABER ESTADO ACTUAL DE LA CONSULTA

  @override
  void initState() {
    super.initState();

    dbHelper = DBHelper();
    analisisDatos();
    refreshList();


  }

  void refreshList() async {
    setState(() {
      recordatorios = dbHelper.getRecordatorios3();
    });
    print(controller.text);
  }
  void analisisDatos() async{
    decodificarDiario= await dbHelper.decodificar();
    decodificarSemanal=await dbHelper.decodificar2();
    decodificarProgramado= await dbHelper.decodificar3();
    int longdiario=decodificarDiario.length;
    int longsemanal=decodificarSemanal.length;
    int longprogramado=decodificarProgramado.length;
    var anioactual=DateTime.now().year;
    var mesactual=DateTime.now().month;
    var diaactual=DateTime.now().day;
    var horasactuales=DateTime.now().hour;
    var minactual=DateTime.now().minute;
    var segactual=DateTime.now().second;


    for(int i=0;i<longdiario;i++){
      var anio=int.parse((decodificarDiario[i]["fecha"]).substring(0,4));
      var mes=int.parse((decodificarDiario[i]["fecha"]).substring(5,7));
      var dia=int.parse((decodificarDiario[i]["fecha"]).substring(8,10));
      var hora=int.parse((decodificarDiario[i]["hora"]).substring(0,2));
      var minutos=int.parse((decodificarDiario[i]["hora"]).substring(3,5));
      var segundos=int.parse((decodificarDiario[i]["hora"]).substring(6,8));
      var nombre=decodificarDiario[i]["nombre"];
      var descripcion=decodificarDiario[i]["descripcion"];
      var horacompleta=decodificarDiario[i]["hora"];
      var diaConcatenar=dia+1;
      var diaConcatenarcomplete;
      if(diaConcatenar>0 && diaConcatenar<10){
        diaConcatenarcomplete="0"+diaConcatenar.toString();
      }
      else{
        diaConcatenarcomplete=diaConcatenar.toString();
      }
      var fechacompleta=anio.toString()+"-"+(decodificarDiario[i]["fecha"]).substring(5,7) +"-"+diaConcatenarcomplete;
      if(anio<anioactual){
        print("ya paso el evento año");
        almacendiario.add(decodificarDiario[i]["id"]);
        completados complete=completados(null,decodificarDiario[i]["id"],"Diario",decodificarDiario[i]["nombre"],decodificarDiario[i]["fecha"],decodificarDiario[i]["hora"],decodificarDiario[i]["descripcion"]);
        dbHelper.insert4(complete);
        Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
        dbHelper.insert(rec);

      }
      else if(anio==anioactual){
        print("el añño es el misp");
        if(mes<mesactual){
          print("ya paso el evento mes");
          almacendiario.add(decodificarDiario[i]["id"]);
          completados complete=completados(null,decodificarDiario[i]["id"],"Diario",decodificarDiario[i]["nombre"],decodificarDiario[i]["fecha"],decodificarDiario[i]["hora"],decodificarDiario[i]["descripcion"]);
          dbHelper.insert4(complete);
          Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
          dbHelper.insert(rec);
        }
        else if(mes==mesactual){
          print("mismo mes");
          if(dia<diaactual){
            print("el evento paso dia");
            almacendiario.add(decodificarDiario[i]["id"]);
            completados complete=completados(null,decodificarDiario[i]["id"],"Diario",decodificarDiario[i]["nombre"],decodificarDiario[i]["fecha"],decodificarDiario[i]["hora"],decodificarDiario[i]["descripcion"]);
            dbHelper.insert4(complete);
            Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
            dbHelper.insert(rec);
          }
          else if(dia==diaactual){
            print("mismo dia");
            if(hora<horasactuales){
              print("el evento ya paso horas");
              almacendiario.add(decodificarDiario[i]["id"]);
              completados complete=completados(null,decodificarDiario[i]["id"],"Diario",decodificarDiario[i]["nombre"],decodificarDiario[i]["fecha"],decodificarDiario[i]["hora"],decodificarDiario[i]["descripcion"]);
              dbHelper.insert4(complete);
              Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
              dbHelper.insert(rec);
            }
            else if(hora==horasactuales){
              print("horas actuales");
              if(minutos<minactual){
                print("el evento ya paso minutos");
                almacendiario.add(decodificarDiario[i]["id"]);
                completados complete=completados(null,decodificarDiario[i]["id"],"Diario",decodificarDiario[i]["nombre"],decodificarDiario[i]["fecha"],decodificarDiario[i]["hora"],decodificarDiario[i]["descripcion"]);
                dbHelper.insert4(complete);//agregar a completados
                Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
                dbHelper.insert(rec);
              }
              else if(minutos==minactual){
                if(segundos<segactual){
                  print("el evento ya paso segudnoss");
                  almacendiario.add(decodificarDiario[i]["id"]);
                  completados complete=completados(null,decodificarDiario[i]["id"],"Diario",decodificarDiario[i]["nombre"],decodificarDiario[i]["fecha"],decodificarDiario[i]["hora"],decodificarDiario[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
                  dbHelper.insert(rec);
                }
                else if(segundos==segactual){
                  print("el evento llego");
                  almacendiario.add(decodificarDiario[i]["id"]);
                  completados complete=completados(null,decodificarDiario[i]["id"],"Diario",decodificarDiario[i]["nombre"],decodificarDiario[i]["fecha"],decodificarDiario[i]["hora"],decodificarDiario[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
                  dbHelper.insert(rec);
                }
              }
            }
          }
        }

      }



    }
    int longalmacendiario=almacendiario.length;
    print(longalmacendiario);
    for(int i=0;i<longalmacendiario;i++){
      print(almacendiario[i]);
      dbHelper.delete(almacendiario[i]);
    }


    for(int i=0;i<longsemanal;i++){
      var anio=int.parse((decodificarSemanal[i]["fecha"]).substring(0,4));
      var mes=int.parse((decodificarSemanal[i]["fecha"]).substring(5,7));
      var dia=int.parse((decodificarSemanal[i]["fecha"]).substring(8,10));
      var hora=int.parse((decodificarSemanal[i]["hora"]).substring(0,2));
      var minutos=int.parse((decodificarSemanal[i]["hora"]).substring(3,5));
      var segundos=int.parse((decodificarSemanal[i]["hora"]).substring(6,8));
      var nombre=decodificarSemanal[i]["nombre"];
      var descripcion=decodificarSemanal[i]["descripcion"];
      var horacompleta=decodificarSemanal[i]["hora"];
      int dianuevo;
      int mesnuevo;
      int anionuevo;
      String dianuevocadena;
      String mesnuevocadena;
      if (mes==1 || mes==3 || mes==5 || mes == 7 || mes==8 || mes==10 || mes==12){
        dianuevo=dia + 7;
        mesnuevo=mes;
        anionuevo=anio;
        if (dianuevo>31){
          dianuevo-=31;
          mesnuevo=mes+1;
          if(mesnuevo>12){
            mesnuevo-=12;
            anionuevo=anio+1;
          }
        }
      }
      else if(mes==2){
        dianuevo= dia+7;
        if(dianuevo>28){
          dianuevo-=28;
          mesnuevo=mes+1;
        }
      }
      else if(mes==4 || mes==6 || mes==9 || mes==11){
        dianuevo=dia+1;
        if(dianuevo>30){
          dianuevo-=30;
          mes+=1;
        }
      }

      if(dianuevo>0 && dianuevo<10){
        dianuevocadena="0"+dianuevo.toString();
      }
      else{
        dianuevocadena=dianuevo.toString();
      }

      if (mesnuevo>0 && mesnuevo<10){
        mesnuevocadena="0"+mesnuevo.toString();
      }
      else{
        mesnuevocadena=mesnuevo.toString();
      }
      var fechacompleta= anionuevo.toString()+"-"+mesnuevocadena+"-"+dianuevocadena;


      if(anio<anioactual){
        print("ya paso el evento año");
        almacensemanal.add(decodificarSemanal[i]["id"]);
        completados complete=completados(null,decodificarSemanal[i]["id"],"Semanal",decodificarSemanal[i]["nombre"],decodificarSemanal[i]["fecha"],decodificarSemanal[i]["hora"],decodificarSemanal[i]["descripcion"]);
        dbHelper.insert4(complete);
        Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
        dbHelper.insert2(rec);
      }
      else if(anio==anioactual){
        print("el añño es el misp");
        if(mes<mesactual){
          print("ya paso el evento mes");
          almacensemanal.add(decodificarSemanal[i]["id"]);
          completados complete=completados(null,decodificarSemanal[i]["id"],"Semanal",decodificarSemanal[i]["nombre"],decodificarSemanal[i]["fecha"],decodificarSemanal[i]["hora"],decodificarSemanal[i]["descripcion"]);
          dbHelper.insert4(complete);
          Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
          dbHelper.insert2(rec);
        }
        else if(mes==mesactual){
          print("mismo mes");
          if(dia<diaactual){
            print("el evento paso dia");
            almacensemanal.add(decodificarSemanal[i]["id"]);
            completados complete=completados(null,decodificarSemanal[i]["id"],"Semanal",decodificarSemanal[i]["nombre"],decodificarSemanal[i]["fecha"],decodificarSemanal[i]["hora"],decodificarSemanal[i]["descripcion"]);
            dbHelper.insert4(complete);
            Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
            dbHelper.insert2(rec);
          }
          else if(dia==diaactual){
            print("mismo dia");
            if(hora<horasactuales){
              print("el evento ya paso horas");
              almacensemanal.add(decodificarSemanal[i]["id"]);
              completados complete=completados(null,decodificarSemanal[i]["id"],"Semanal",decodificarSemanal[i]["nombre"],decodificarSemanal[i]["fecha"],decodificarSemanal[i]["hora"],decodificarSemanal[i]["descripcion"]);
              dbHelper.insert4(complete);
              Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
              dbHelper.insert2(rec);
            }
            else if(hora==horasactuales){
              print("horas actuales");
              if(minutos<minactual){
                print("el evento ya paso minutos");
                almacensemanal.add(decodificarSemanal[i]["id"]);
                completados complete=completados(null,decodificarSemanal[i]["id"],"Semanal",decodificarSemanal[i]["nombre"],decodificarSemanal[i]["fecha"],decodificarSemanal[i]["hora"],decodificarSemanal[i]["descripcion"]);
                dbHelper.insert4(complete);
                Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
                dbHelper.insert2(rec);
              }
              else if(minutos==minactual){
                if(segundos<segactual){
                  print("el evento ya paso segudnoss");
                  almacensemanal.add(decodificarSemanal[i]["id"]);
                  completados complete=completados(null,decodificarSemanal[i]["id"],"Semanal",decodificarSemanal[i]["nombre"],decodificarSemanal[i]["fecha"],decodificarSemanal[i]["hora"],decodificarSemanal[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
                  dbHelper.insert2(rec);

                }
                else if(segundos==segactual){
                  print("el evento llego");
                  almacensemanal.add(decodificarSemanal[i]["id"]);
                  completados complete=completados(null,decodificarSemanal[i]["id"],"Semanal",decodificarSemanal[i]["nombre"],decodificarSemanal[i]["fecha"],decodificarSemanal[i]["hora"],decodificarSemanal[i]["descripcion"]);
                  dbHelper.insert4(complete);
                  Recordatorio rec= Recordatorio(null,nombre,fechacompleta,horacompleta,descripcion);
                  dbHelper.insert2(rec);
                }
              }
            }
          }
        }

      }

    }

    int longalmacensemanal=almacensemanal.length;
    for(int i=0;i<longalmacensemanal;i++){
      print(almacensemanal[i]);
      dbHelper.delete2(almacensemanal[i]);
    }


    for(int i=0;i<longprogramado;i++){
      var anio=int.parse((decodificarProgramado[i]["fecha"]).substring(0,4));
      var mes=int.parse((decodificarProgramado[i]["fecha"]).substring(5,7));
      var dia=int.parse((decodificarProgramado[i]["fecha"]).substring(8,10));
      var hora=int.parse((decodificarProgramado[i]["hora"]).substring(0,2));
      var minutos=int.parse((decodificarProgramado[i]["hora"]).substring(3,5));
      var segundos=int.parse((decodificarProgramado[i]["hora"]).substring(6,8));
      if(anio<anioactual){
        print("ya paso el evento año");
        almacenprogramado.add(decodificarProgramado[i]["id"]);
        completados complete=completados(null,decodificarProgramado[i]["id"],"Programado",decodificarProgramado[i]["nombre"],decodificarProgramado[i]["fecha"],decodificarProgramado[i]["hora"],decodificarProgramado[i]["descripcion"]);
        dbHelper.insert4(complete);
      }
      else if(anio==anioactual){
        print("el añño es el misp");
        if(mes<mesactual){
          print("ya paso el evento mes");
          almacenprogramado.add(decodificarProgramado[i]["id"]);
          completados complete=completados(null,decodificarProgramado[i]["id"],"Programado",decodificarProgramado[i]["nombre"],decodificarProgramado[i]["fecha"],decodificarProgramado[i]["hora"],decodificarProgramado[i]["descripcion"]);
          dbHelper.insert4(complete);
        }
        else if(mes==mesactual){
          print("mismo mes");
          if(dia<diaactual){
            print("el evento paso dia");
            almacenprogramado.add(decodificarProgramado[i]["id"]);
            completados complete=completados(null,decodificarProgramado[i]["id"],"Programado",decodificarProgramado[i]["nombre"],decodificarProgramado[i]["fecha"],decodificarProgramado[i]["hora"],decodificarProgramado[i]["descripcion"]);
            dbHelper.insert4(complete);
          }
          else if(dia==diaactual){
            print("mismo dia");
            if(hora<horasactuales){
              print("el evento ya paso horas");
              almacenprogramado.add(decodificarProgramado[i]["id"]);
              completados complete=completados(null,decodificarProgramado[i]["id"],"Programado",decodificarProgramado[i]["nombre"],decodificarProgramado[i]["fecha"],decodificarProgramado[i]["hora"],decodificarProgramado[i]["descripcion"]);
              dbHelper.insert4(complete);
            }
            else if(hora==horasactuales){
              print("horas actuales");
              if(minutos<minactual){
                print("el evento ya paso minutos");
                almacenprogramado.add(decodificarProgramado[i]["id"]);
                completados complete=completados(null,decodificarProgramado[i]["id"],"Programado",decodificarProgramado[i]["nombre"],decodificarProgramado[i]["fecha"],decodificarProgramado[i]["hora"],decodificarProgramado[i]["descripcion"]);
                dbHelper.insert4(complete);
              }
              else if(minutos==minactual){
                if(segundos<segactual){
                  print("el evento ya paso segudnoss");
                  almacenprogramado.add(decodificarProgramado[i]["id"]);
                  completados complete=completados(null,decodificarProgramado[i]["id"],"Programado",decodificarProgramado[i]["nombre"],decodificarProgramado[i]["fecha"],decodificarProgramado[i]["hora"],decodificarProgramado[i]["descripcion"]);
                  dbHelper.insert4(complete);
                }
                else if(segundos==segactual){
                  print("el evento llego");
                  almacenprogramado.add(decodificarProgramado[i]["id"]);
                  completados complete=completados(null,decodificarProgramado[i]["id"],"Programado",decodificarProgramado[i]["nombre"],decodificarProgramado[i]["fecha"],decodificarProgramado[i]["hora"],decodificarProgramado[i]["descripcion"]);
                  dbHelper.insert4(complete);
                }
              }
            }
          }
        }

      }
      int longalmacenprogramado=almacenprogramado.length;
      for(int i=0;i<longalmacenprogramado;i++){
        dbHelper.delete3(almacenprogramado[i]);
      }



    }

  }


  void cleanData() {
    controller.text = "";
  }
  final _scaffoldkey = GlobalKey<ScaffoldState>();


  _showSnackbar(BuildContext context, String texto) {
    final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontFamily: 'Schyler',
              fontWeight: FontWeight.bold,
            )));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        resizeToAvoidBottomPadding: false ,
        key: _scaffoldkey,
        appBar: new AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text("Recordatorios Programados",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        body:Container(
          child: FutureBuilder(
            future: recordatorios,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("DATA VALUE:$snapshot.data[index].name.toSring()");
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child:Card(
                          color: Colors.greenAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),

                              GestureDetector(child:Text(
                                "${snapshot.data[index].nombre} ",
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => actualizacionProgramado(snapshot.data[index].id)));
                              },),
                              Padding(padding: EdgeInsets.all(5),),
                              GestureDetector(child:Text("Fecha: "
                                "${snapshot.data[index].fecha} ",
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => actualizacionProgramado(snapshot.data[index].id)));
                              },),
                              Padding(padding: EdgeInsets.all(5),),
                              GestureDetector(child:Text("Hora: "
                                "${snapshot.data[index].hora} ",
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),onTap: (){
                               Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => actualizacionProgramado(snapshot.data[index].id)));
                              },),
                              Padding(padding: EdgeInsets.all(5),),
                              GestureDetector(child:Text("Descripcion: "
                                "${snapshot.data[index].descripcion} ",
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => actualizacionProgramado(snapshot.data[index].id)));
                              },),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  FlatButton.icon(
                                      color: Colors.black,
                                      icon: Icon(Icons.cancel, color: Colors.white),
                                      label: Text("Cancelar", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        cancelar(snapshot.data[index].id);
                                        _showSnackbar(context,
                                            "El reordatorio se cancelo correctamente");
                                      },
                                  ),
                                  SizedBox(width: 5),
                                  FlatButton.icon(
                                    onPressed: () {
                                      cancelar(snapshot.data[index].id);
                                      dbHelper.delete3(snapshot.data[index].id);
                                      _showSnackbar(context,
                                          "El recordatorio se cancelo y se elimino correctamente");
                                      refreshList();
                                    },
                                    color: Colors.red,
                                    icon: Icon(Icons.delete, color: Colors.white),
                                    label: Text("Eliminar", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                    )),
                                  ),
                                  SizedBox(width: 5),
                                  FlatButton.icon(
                                      color: Colors.yellow[700],
                                      icon: Icon(Icons.update, color: Colors.white),
                                      label: Text("Actualizar",style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                      ),
                                    onPressed: () {
                                        refreshList();

                                    },
                                  ),
                              ],),

                              /*Evoluciones*/
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),

                        ),

                      );
//                        ListTile(
//                          leading: new Text(""),
//                          title: new Text(snapshot.data[index].nombre.toString()),
//                          subtitle:
//                          new Text(snapshot.data[index].fecha.toString()),
//                          onTap: () {
//                            Navigator.push(
//                                context,
//                                new MaterialPageRoute(
//                                    builder: (context) =>
//                                        DetailPage(snapshot.data[index])));
//                          }
//                      );
                    });
              }
            },
          ),
        ),
    );
  }



  void cancelar(int id) async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid;
    var initializationSettingsIos;
    var initializationSettings;
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIos);
    await flutterLocalNotificationsPlugin.cancel(id);


  }


}





