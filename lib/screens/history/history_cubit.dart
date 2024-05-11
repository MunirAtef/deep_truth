
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../backend_logic/file_request.dart';
import '../../backend_logic/history_request.dart';
import '../../models/history_item_model.dart';
import '../../resources/main_colors.dart';
import '../../shared_widgets/custom_snake_bar.dart';
import '../../shared_widgets/draw_image_result.dart';
import '../../shared_widgets/loading_dialog.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(): super(HistoryState());

  static HistoryCubit getInstance(BuildContext context) =>
    BlocProvider.of<HistoryCubit>(context);

  List<String> types = ["All", "Images", "Videos"];
  List<String> categories = ["All", "Real", "Fake"];

  String type = "All";
  String category = "All";

  List<HistoryItemModel>? items;
  List<HistoryItemModel>? filteredItems;


  Future<void> getHistoryItems() async {
    items = null;
    items = await HistoryRequest.inst.getHistoryData() ?? [];

    items?.sort((a, b) => b.date - a.date);
    applyFilters();
    emit(HistoryState(updateItemsList: true));
  }

  void applyFilters() {
    if ((type == types[0] && category == categories[0]) || items == null) {
      filteredItems = items;
      return;
    }
    filteredItems = items;
    // filteredItems = items?.toList();
    // for (HistoryItemModel item in items!) {
    //   String itemType = "${item.type}s";
    //
    //   if (category == categories[0] && type != types[0]) {  /// only category = "All"
    //     if (itemType == type) filteredItems?.add(item);
    //   } else if (type == types[0]) {   /// only type = "All"
    //     if (item.category == category) filteredItems?.add(item);
    //   } else {    /// both of them != "All"
    //     if (itemType == type && item.category == category) filteredItems?.add(item);
    //   }
    // }
  }

  void updateType(String? newType) {
    type = newType ?? "All";
    applyFilters();
    emit(HistoryState(updateType: true, updateItemsList: true));
  }

  void updateCategory(String? newCategory) {
    category = newCategory ?? "All";
    applyFilters();
    emit(HistoryState(updateCategory: true, updateItemsList: true));
  }

  void showModelResult(BuildContext context, HistoryItemModel itemModel) async{
    showDialog(
      context: context,
      builder: (context) => ResultDialog(itemModel: itemModel)
    );
  }

  void deleteFromHistory(BuildContext context, String filename) {
    showLoading(
      context: context,
      waitFor: () async {
        bool response = await FileRequest.inst.deleteHistoryFile(filename);

        if (response) {
          items?.removeWhere((element) => element.filename == filename);
          applyFilters();
          emit(HistoryState(updateItemsList: true));
          return;
        }

        CustomSnackBar(context: context, subColor: MainColors.historyPage)
          .show("Failed to delete the file");
      }
    );
  }
}
