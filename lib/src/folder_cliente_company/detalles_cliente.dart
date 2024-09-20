import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/folder_cliente_company/model_cliente/cliente.dart';
import 'package:tejidos/src/util/dialog_confimarcion.dart';
import 'package:tejidos/src/widgets/mensaje_scaford.dart';

import 'provider_clientes/provider_clientes.dart';

class DetallesCliente extends StatefulWidget {
  const DetallesCliente({super.key, required this.item});
  final Cliente item;

  @override
  State<DetallesCliente> createState() => _DetallesClienteState();
}

class _DetallesClienteState extends State<DetallesCliente> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  Future<void> actualizarCliente() async {
    if (nombreController.text.isEmpty || apellidoController.text.isEmpty) {
      return;
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: 'Esta Deguro De Actualizar Datos Del Cliente Actual?',
          titulo: 'Actualización',
          onConfirmar: () async {
            Navigator.of(context).pop();
            final mjs =
                await Provider.of<ClienteProvider>(context, listen: false)
                    .updateMethodCliente(widget.item.toJson());
            if (!mounted) {
              return;
            }
            scaffoldMensaje(
                context: context, background: Colors.green, mjs: mjs);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> deleteCliente() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: '❌ Esta seguro de eliminar este cliente ? ❌',
          titulo: 'Alerta',
          onConfirmar: () async {
            Navigator.of(context).pop();
            final mjs =
                await Provider.of<ClienteProvider>(context, listen: false)
                    .deleteCliente(widget.item.toJson());
            if (!mounted) {
              return;
            }
            scaffoldMensaje(context: context, background: Colors.red, mjs: mjs);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void initState() {
    nombreController.text = widget.item.nombre.toString();
    apellidoController.text = widget.item.apellido.toString();
    direccionController.text = widget.item.direccion.toString();
    telefonoController.text = widget.item.telefono.toString();
    correoController.text = widget.item.correoElectronico.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: nombreController,
                  onChanged: (val) {
                    widget.item.nombre = val;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Nombre *',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: apellidoController,
                  onChanged: (val) {
                    widget.item.apellido = val;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Apellido *',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: direccionController,
                  onChanged: (val) {
                    widget.item.direccion = val;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: telefonoController,
                  onChanged: (val) {
                    widget.item.telefono = val;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: correoController,
                  onChanged: (val) {
                    widget.item.correoElectronico = val;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Infomacion Adicional',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.green)),
                  onPressed: () {
                    actualizarCliente();
                  },
                  child: const Text('Actualizar Cliente',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.red)),
                  onPressed: () {
                    deleteCliente();
                  },
                  child: const Text('Eliminar Cliente',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
