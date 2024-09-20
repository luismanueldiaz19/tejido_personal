import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/folder_serigrafia/widgets/item_serigrafia.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

import '../../widgets/loading.dart';
import 'provider/provider_serigrafia.dart';

class OnlineSerigrafiaWork extends StatefulWidget {
  const OnlineSerigrafiaWork({super.key, required this.current});
  final Department current;

  @override
  State<OnlineSerigrafiaWork> createState() => _OnlineSerigrafiaWorkState();
}

class _OnlineSerigrafiaWorkState extends State<OnlineSerigrafiaWork> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderSerigrafia>(context, listen: false)
          .getWork(widget.current.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final providerList = Provider.of<ProviderSerigrafia>(context, listen: true);

    print(size.width);
    return Scaffold(
      appBar: AppBar(
          title: Text('Trabajos Online ${widget.current.nameDepartment}')),
      body: size.width < 600
          ? Column(
              children: [
                const SizedBox(width: double.infinity),
                providerList.listFilter.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RefreshIndicator(
                            onRefresh: () => Provider.of<ProviderSerigrafia>(
                                    context,
                                    listen: false)
                                .getWork(widget.current.id),
                            child: ListView.builder(
                              itemCount: providerList.listFilter.length,
                              physics: const BouncingScrollPhysics(),
                              itemExtent: 300,
                              itemBuilder: (context, index) {
                                Sublima current =
                                    providerList.listFilter[index];
                                return MyWidgetItemSerigrafia(current: current);
                              },
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Loading(
                            text: providerList.messaje,
                            isLoading: providerList.isLoading),
                      ),
                providerList.listFilter.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: SizedBox(
                          height: 35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              height: 35,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Total : ', style: style.bodySmall),
                                      const SizedBox(width: 10),
                                      Text(
                                          providerList.listFilter.length
                                              .toString(),
                                          style: style.bodySmall?.copyWith(
                                              color: ktejidoBlueOcuro,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                identy(context)
              ],
            )
          : Column(
              children: [
                const SizedBox(width: double.infinity),
                providerList.listFilter.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RefreshIndicator(
                            onRefresh: () => Provider.of<ProviderSerigrafia>(
                                    context,
                                    listen: false)
                                .getWork(widget.current.id),
                            child: SizedBox(
                              width: 450,
                              child: ListView.builder(
                                itemCount: providerList.listFilter.length,
                                physics: const BouncingScrollPhysics(),
                                itemExtent: 300,
                                itemBuilder: (context, index) {
                                  Sublima current =
                                      providerList.listFilter[index];
                                  return MyWidgetItemSerigrafia(
                                      current: current);
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Loading(
                            text: providerList.messaje,
                            isLoading: providerList.isLoading),
                      ),
                providerList.listFilter.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: SizedBox(
                          height: 35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              height: 35,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Total : ', style: style.bodySmall),
                                      const SizedBox(width: 10),
                                      Text(
                                          providerList.listFilter.length
                                              .toString(),
                                          style: style.bodySmall?.copyWith(
                                              color: ktejidoBlueOcuro,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                identy(context)
              ],
            ),
    );
  }
}
