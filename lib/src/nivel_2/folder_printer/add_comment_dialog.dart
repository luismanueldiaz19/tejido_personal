import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/detail_print_orden.dart';

class AddComentDialog extends StatefulWidget {
  const AddComentDialog({super.key, required this.item});
  final DetailPrinterOrden item;

  @override
  State<AddComentDialog> createState() => _AddComentDialogState();
}

class _AddComentDialogState extends State<AddComentDialog> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  _submitComment() async {
    if (commentController.text.isNotEmpty) {
      // Obtener el comentario ingresado
      String comment = commentController.text;
      var data = {
        'id': widget.item.id,
        'comment': '${widget.item.comment} - $comment',
      };
      String updatePrinterWork =
          "http://$ipLocal/settingmat/admin/update/update_printer_work_comment.php";
      await httpRequestDatabase(updatePrinterWork, data);
      // print(res.body);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Comentario'),
      content: TextField(
        controller: commentController,
        decoration: const InputDecoration(labelText: 'Comentario'),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Enviar'),
          onPressed: () {
            _submitComment();
          },
        ),
      ],
    );
  }
}
