import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/locator_service.dart' as di;

import 'feature/presentation/block/person_list_cubit/person_list_cubit.dart';
import 'feature/presentation/block/search_bloc/search_bloc.dart';
import 'feature/presentation/pages/person_screen.dart';
import 'locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonListCubit>(
            create: (context) => sl<PersonListCubit>()..loadPerson()),
        BlocProvider<PersonSearchBloc>(
            create: (context) => sl<PersonSearchBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
        ),
        home: HomePage()
      ),
    );
  }
}
