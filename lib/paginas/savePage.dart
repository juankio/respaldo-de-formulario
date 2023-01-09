import 'package:apis/db/operation.dart';
import 'package:apis/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SavePage extends StatefulWidget {
  static const String ROUTE = "/save";

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  final _formKey = GlobalKey<FormState>();
  var cardTarjeta = MaskTextInputFormatter(
      mask: 'CC #.###.###-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  var fecha = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var code = MaskTextInputFormatter(
      mask: '###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var telefono = MaskTextInputFormatter(
      mask: '+## (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final NombreController = TextEditingController();
  final edadController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();
  final fechaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Note note = ModalRoute.of(context)!.settings.arguments as Note;
    _init(note);

    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Guardar"),
        ),
        body: Container(
          child: _buildForm(note),
        ),
      ),
    );
  }

  _init(Note note) {
    NombreController.text = note.nombre;
    edadController.text = note.edad;
    telefonoController.text = note.telefono;
    correoController.text = note.correo;
    fechaController.text = note.fecha;
  }

  Widget _buildForm(Note note) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: NombreController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colocar data";
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Nombre",
                  border:
                      OutlineInputBorder() //borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: telefonoController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colocar un telefono";
                }
                return null;
              },
              inputFormatters: [telefono],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Telefono",
                  border:
                      OutlineInputBorder() //borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: edadController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colocar la edad";
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Edad",
                  border:
                      OutlineInputBorder() //borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: correoController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colocar un Correo electronico";
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Correo",
                  border:
                      OutlineInputBorder() //borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: fechaController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colocar una Cedula";
                }
                return null;
              },
              inputFormatters: [cardTarjeta],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "cedula",
                  border:
                      OutlineInputBorder() //borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
            ),
            MaterialButton(
              child: Text("Guardar"),
              color: Colors.blue,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (note.id > 0) {
                    // actualizacion
                    note.nombre = NombreController.text;
                    note.edad = edadController.text;
                    note.telefono = telefonoController.text;
                    note.correo = correoController.text;
                    note.fecha = fechaController.text;
                    Operation.update(note);
                  } else {
                    // insercion
                    Operation.insert(Note(
                      nombre: NombreController.text,
                      edad: edadController.text,
                      telefono: telefonoController.text,
                      correo: correoController.text,
                      fecha: fechaController.text,
                    ));
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPopScope() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('¿Seguro que quieres salir del formulario? '),
                  content: Text('Tienes datos sin guardar'),
                  actions: [
                    MaterialButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('No')),
                    MaterialButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Si'))
                  ],
                ))) ??
        false;
  }
}
