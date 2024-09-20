import 'package:flutter/material.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

import '../model/department.dart';
import '../nivel_2/folder_satreria/model/type_works.dart';
import '../widgets/dialog_get_deparment.dart';
import 'add_form_new_work.dart';

class MyWidgetDetailsPhotoView extends StatefulWidget {
  const MyWidgetDetailsPhotoView({super.key, required this.data});
  final TypeWorks data;

  @override
  State<MyWidgetDetailsPhotoView> createState() =>
      _MyWidgetDetailsPhotoViewState();
}

class _MyWidgetDetailsPhotoViewState extends State<MyWidgetDetailsPhotoView> {
  TextEditingController controllerUrlImagen = TextEditingController();
  TextEditingController controllerTypeWorkName = TextEditingController();
  Department? depart;

  @override
  void initState() {
    super.initState();
    controllerUrlImagen.text = widget.data.imageTypeWork ?? 'N/A';
    controllerTypeWorkName.text = widget.data.nameTypeWork ?? 'N/A';
    depart = Department(nameDepartment: widget.data.areaWorkSastreria);
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Hero(
                    tag: widget.data.imageTypeWork.toString(),
                    child: Center(
                      child: Image.network(
                        height: sized.height / 2,
                        width: sized.width,
                        widget.data.imageTypeWork ?? 'M/A',
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          );
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('Error al cargar la imagen',
                              textAlign: TextAlign.center);
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(1.0)),
            width: 250,
            height: 40,
            alignment: Alignment.center,
            child: TextButton(
                onPressed: () async {
                  Department? res = await showDialog<Department>(
                      context: context,
                      builder: (context) {
                        return const DialogGetDeparment();
                      });
                  if (res != null) {
                    setState(() {
                      depart = res;
                    });
                  }
                },
                child: depart != null
                    ? Text(depart?.nameDepartment ?? 'N/A')
                    : const Text('Area/Departamento?')),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(1.0)),
            width: 250,
            child: TextField(
              controller: controllerTypeWorkName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Trabajo',
                label: Text('Escribir tipo'),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(1.0)),
            width: 250,
            child: TextField(
              keyboardType: TextInputType.text,
              controller: controllerUrlImagen,
              decoration: InputDecoration(
                hintText: 'Url Imagen',
                label: const Text('Url Imagen'),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15),
                errorText: controllerUrlImagen.text.isNotEmpty
                    ? !isValidUrl(controllerUrlImagen.text)
                        ? 'URL no válida'
                        : null
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                // setState(() {
                //   addNew();
                // });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => colorsBlueTurquesa)),
              child: const Text('Actualizar',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
