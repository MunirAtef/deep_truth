
import 'package:deep_truth/screens/search_users/user_list_item.dart';
import 'package:flutter/material.dart';

import 'connections_cubit.dart';

class Connected extends StatelessWidget {
  const Connected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectionsCubit cubit = ConnectionsCubit.getInstance(context);

    return ListView.builder(
      itemCount: cubit.connections.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      itemBuilder: (context, index) => UserListItem(
        model: cubit.connections[index]
      )
    );
  }
}

