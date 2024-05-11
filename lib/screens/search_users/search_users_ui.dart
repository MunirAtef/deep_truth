
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/main_colors.dart';
import '../../shared_widgets/custom_text_field.dart';
import '../../shared_widgets/no_result.dart';
import '../../shared_widgets/screen_background.dart';
import 'search_users_cubit.dart';
import 'search_users_state.dart';
import 'user_list_item.dart';

class SearchUsers extends StatelessWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color subColor = MainColors.searchUsersPage;
    SearchUsersCubit cubit = SearchUsersCubit.getInstance(context);

    return ScreenBackground(
      title: "SEARCH",
      appBarColor: subColor,
      body: Column(
        children: [
          CustomTextField(
            controller: cubit.searchController,
            hint: "Search...",
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            prefix: const Icon(Icons.search),
            suffix: IconButton(
              onPressed: cubit.search,
              icon: const Icon(Icons.done)
            ),
          ),

          Expanded(
            child: BlocBuilder<SearchUsersCubit, SearchUsersState>(
              buildWhen: (ps, cs) => cs.updateSearchList,
              builder: (context, state) {
                if (cubit.isLoading) {
                  return Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: LinearProgressIndicator(
                          color: subColor,
                          backgroundColor: MainColors.appColorDark
                        ),
                      ),
                    ],
                  );
                }

                if (cubit.users.isEmpty) {
                  return const NoResult(message: "No users found", color: subColor);
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: cubit.users.length,
                  itemBuilder: (context, int index) => UserListItem(
                    model: cubit.users[index]
                  )
                );
              }
            )
          ),
        ],
      ),
    );
  }
}

