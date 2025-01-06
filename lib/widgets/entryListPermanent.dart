import 'package:diary/models/dailyEntry_model.dart';
import 'package:diary/widgets/entryDialog.dart';
import 'package:diary/widgets/scaleBarEntries.dart';
import 'package:flutter/material.dart';

class EntryListPermanent extends StatefulWidget {
  const EntryListPermanent({super.key, required this.entryListPermanent});

  final List<DailyEntry> entryListPermanent;

  @override
  State<EntryListPermanent> createState() => _EntryListPermanentState();
}

class _EntryListPermanentState extends State<EntryListPermanent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.entryListPermanent.length,
      itemBuilder: ((
        context,
        index,
      ) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Card(
                color: Colors.transparent,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(entryList[index].type?['icon']),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                widget.entryListPermanent[index]
                                        .type?["name"] ??
                                    "Failed to get type",
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              margin:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ScaleBarEntries(
                                editingValues: false,
                                scaleValue: int.parse(
                                    "${widget.entryListPermanent[index].scale}"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => EntryDialog(
                      editEntry: true,
                      scaleEdit: int.parse(
                          "${widget.entryListPermanent[index].scale}"),
                      selectedTypeEdit: widget.entryListPermanent[index].type,
                      entryId: widget.entryListPermanent[index].id,
                      permanentEdit: widget.entryListPermanent[index].permanent,
                    ),
                  );
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
