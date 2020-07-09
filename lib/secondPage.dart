import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'insertadiario.dart';
import 'programado.dart';
import 'semanal.dart';
import 'crud_operations.dart';
import 'recordatorio.dart';
import 'mostrarprogramadotarjeta.dart';
import 'mostrardiariotarjeta.dart';
import 'mostrarsemanaltarjeta.dart';
import 'mostrarcompletados.dart';

class LocalNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: 'Titulo de la App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Notificaciones'));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //declarar el plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIos;
  var initializationSettings;

  void _showNotification() async {
    await _simpleScheduleNotification();
  }

  Future<void> _simpleScheduleNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name', 'channel_description',
        importance: Importance.Max,
        priority: Priority.Max,
        ticker: 'Test Ticker');

    var IOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, IOSPlatformChannelSpecifics);
    var now = new DateTime.now();
    //notificacion a los 3 minutos
    var reprogram = now.add(Duration(hours: 00, minutes: 00, seconds: 10));
    //id aleatorio tiene que ser pero por ahora estatico
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Esta es la primera Notificacion',
        'Hola desde la primera notificacion',
        reprogram,
        platformChannelSpecifics,
        payload: "Hello from my data");

    ///ver la hora programada
    Fluttertoast.showToast(
        msg: 'Scheduled at time $reprogram',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  var dbHelper;
  List<Map> listarec;
  List<Map> decodificarDiario;
  List<Map> decodificarSemanal;
  List<Map> decodificarProgramado;
  List almacendiario = List<dynamic>();
  List almacensemanal = List<dynamic>();
  List almacenprogramado = List<dynamic>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettingsIos = new IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIos);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
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

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
//      await Navigator.push(
//          context, new MaterialPageRoute(
//          builder: (context) => new SecondPage(payload: payload,)));
    } else {
      await Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new LocalNotification()));
    }
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(body),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Ok"),
                    onPressed: () async {
//                      Navigator.of(context, rootNavigator: true).pop();
//                      await Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => SecondPage(payload: payload,)));
                    },
                  )
                ]));
    print("called on did receive local notification");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: new Text("Home",
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20)),
        ),
        drawer: new Drawer(
            child: new ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text("Recordatorios",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              new ListTile(
                  title: new Text("Crear recordatorio diario", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                  trailing: new Icon(Icons.add_alert, color: Colors.yellow[700]),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => diario()));
                  }),
                SizedBox(
                  height: 5.0,
                ),
              new ListTile(
                  title: new Text("Crear recordatorio semanal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                  trailing: new Icon(Icons.add_alert,  color: Colors.yellow[700]),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => semanal()));
                  }),
                SizedBox(
                  height: 5.0,
                ),

              new ListTile(
                  title: new Text("Crear recordatorio Programado", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                  trailing: new Icon(Icons.add_alert,  color: Colors.yellow[700]),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => programado()));
                  }),
                SizedBox(
                  height: 5.0,
                ),
                new ListTile(
                    title: new Text("Recordatorios diarios creados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                    trailing: new Icon(Icons.search, color: Colors.lightBlue),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => mostrarTarjetaDiario()));
                    }),
                SizedBox(
                  height: 5.0,
                ),
                new ListTile(
                    title: new Text("Recordatorios semanales creados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                    trailing: new Icon(Icons.search, color: Colors.lightBlue),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => mostrarTarjetaSemanal()));
                    }),
                SizedBox(
                  height: 5.0,
                ),
                new ListTile(
                    title: new Text("Recordatorios programados creados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                    trailing: new Icon(Icons.search, color: Colors.lightBlue),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => mostrarTarjetaProgramado()));
                    }),
                SizedBox(
                  height: 5.0,
                ),
                new ListTile(
                    title: new Text("Recordatorios completados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                    trailing: new Icon(Icons.search, color: Colors.lightBlue),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => mostrarCompletados()));
                    }),
            ],
        )),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              MaterialButton(
                  child: Icon(Icons.notification_important),
                  onPressed: _showNotification,
                  color: Colors.redAccent),
              SizedBox(
                width: 20,
                height: 20,
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text(
                  'Cancel notification',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                onPressed: () async {
                  await flutterLocalNotificationsPlugin.cancel(0);
                },
              )
            ],
        )));
  }
}
