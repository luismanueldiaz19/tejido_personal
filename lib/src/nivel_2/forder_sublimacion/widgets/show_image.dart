import 'package:flutter/material.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/image_get_path_file.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

class ShowImageFile extends StatefulWidget {
  const ShowImageFile(
      {Key? key,
      required this.images,
      required this.current,
      required this.urlImage})
      : super(key: key);
  final List<ImageGetPathFile> images;
  final Sublima current;
  final String urlImage;

  @override
  State<ShowImageFile> createState() => _ShowImageFileState();
}

class _ShowImageFileState extends State<ShowImageFile> {
  // '$urlImage${current.imagePath}'
  @override
  Widget build(BuildContext context) {
    var textSize = 15.0;
    // final size = MediaQuery.of(context).size;
    // // print(size);

    // /////// de 0 a 600
    // if (size.width > 0 && size.width <= 600) {
    //   textSize = size.width * 0.020;
    // } else {
    //   textSize = size.width * 0.035;
    // }

    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Imagen de la orden'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Logo : ${widget.current.nameLogo.toString()}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: textSize),
              ),
              Column(
                children: [
                  Text(
                    'Num Orden ${widget.current.numOrden.toString()}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: textSize),
                  ),
                  Text(
                    'Ficha : ${widget.current.ficha.toString()}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: textSize),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                ImageGetPathFile current = widget.images[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        '${widget.urlImage}${current.imagePath}',
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: Text('Loading...'));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Error Imagen');
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
