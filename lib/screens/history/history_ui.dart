
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/main_colors.dart';
import '../../shared_widgets/custom_drop_down_menu.dart';
import '../../shared_widgets/loading.dart';
import '../../shared_widgets/no_result.dart';
import '../../shared_widgets/screen_background.dart';
import 'history_cubit.dart';
import 'history_item/history_image.dart';
import 'history_state.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const subColor = MainColors.historyPage;
    HistoryCubit cubit = HistoryCubit.getInstance(context);
    cubit.getHistoryItems();

    return ScreenBackground(
      addBackIcon: false,
      title: "HISTORY",
      appBarColor: subColor,

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            width: double.infinity,
            height: 48,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(200, 200, 200, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              )
            ),

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(
                    width: 230,
                    child: BlocBuilder<HistoryCubit, HistoryState>(
                      buildWhen: (ps, cs) => cs.updateType,
                      builder: (context, state) {
                        return CustomDropDownMenu(
                          subColor: subColor,
                          widthForHint: 80,
                          margin: const EdgeInsets.fromLTRB(0, 4, 5, 4),
                          hintText: "Type",
                          placeholder: cubit.type,
                          items: cubit.types,
                          onChange: cubit.updateType,
                        );
                      }
                    ),
                  ),

                  SizedBox(
                    width: 230,
                    child: BlocBuilder<HistoryCubit, HistoryState>(
                      buildWhen: (ps, cs) => cs.updateCategory,
                      builder: (context, state) {
                        return CustomDropDownMenu(
                          subColor: subColor,
                          widthForHint: 80,
                          margin: const EdgeInsets.fromLTRB(5, 4, 0, 4),
                          hintText: "Category",
                          placeholder: cubit.category,
                          items: cubit.categories,
                          onChange: cubit.updateCategory,
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              buildWhen: (ps, cs) => cs.updateItemsList,
              builder: (context, state) {
                if (cubit.filteredItems == null) {
                  return const Loading(subColor: subColor);
                } else if (cubit.filteredItems!.isEmpty) {
                  return const NoResult(message: "No items found", color: subColor);
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                  itemCount: cubit.filteredItems!.length,
                  itemBuilder: (context, index) => HistoryImage(
                    itemModel: cubit.filteredItems![index],
                  )
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
