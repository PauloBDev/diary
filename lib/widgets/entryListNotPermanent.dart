import 'package:diary/models/dailyEntry_model.dart';
import 'package:diary/models/dailyType_model.dart';
import 'package:diary/widgets/entryDialog.dart';
import 'package:diary/widgets/scaleBarEntries.dart';
import 'package:flutter/material.dart';

class EntryListNotPermanent extends StatefulWidget {
  const EntryListNotPermanent({
    super.key,
    required this.entryList,
    required this.typeListNotifier,
  });

  final List<DailyEntry> entryList;
  final ValueNotifier<List<DailyType>> typeListNotifier;

  @override
  State<EntryListNotPermanent> createState() => _EntryListNotPermanentState();
}

class _EntryListNotPermanentState extends State<EntryListNotPermanent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.entryList.length,
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
                                widget.entryList[index].type?["name"] ??
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
                                    "${widget.entryList[index].scale}"),
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
                      scaleEdit: int.parse("${widget.entryList[index].scale}"),
                      selectedTypeEdit: widget.entryList[index].type,
                      entryId: widget.entryList[index].id,
                      permanentEdit: widget.entryList[index].permanent,
                      typeListNotifier: widget.typeListNotifier,
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
