
import 'package:flutter/material.dart';

import '../../../models/history_item_model.dart';
import '../../../resources/main_colors.dart';
import '../../../shared_widgets/custom_container.dart';
import '../history_cubit.dart';

class BottomSheetButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Icon leading;
  final Color color;

  const BottomSheetButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.leading,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () => onPressed(),
        style: TextButton.styleFrom(
          foregroundColor: MainColors.historyPage
        ),
        child: Row(
          children: [
            leading,

            const SizedBox(width: 10),

            Text(
              text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: color
              )
            ),
          ],
        )
      ),
    );
  }
}


class HistoryItemOptions extends StatelessWidget {
  final HistoryItemModel itemModel;
  final bool sameUser;
  final Color color;
  const HistoryItemOptions({
    Key? key,
    required this.itemModel,
    this.color = MainColors.userProfilePage,
    this.sameUser = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoryCubit cubit = HistoryCubit.getInstance(context);

    return CustomContainer(
      padding: const EdgeInsets.symmetric(vertical: 20),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20)
      ),
      shadowColor: const Color.fromRGBO(60, 60, 60, 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.showModelResult(context, itemModel);
            },
            text: "SEE MODEL RESULT",
            leading: Icon(Icons.face, color: color),
            color: color
          ),

          BottomSheetButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "DOWNLOAD",
            leading: Icon(Icons.download, color: color),
            color: color,
          ),

          if (sameUser) BottomSheetButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteFromHistory(context, itemModel.filename);
            },
            text: "DELETE FROM HISTORY",
            leading: Icon(Icons.delete, color: color),
            color: color
          ),
        ],
      ),
    );
  }
}

