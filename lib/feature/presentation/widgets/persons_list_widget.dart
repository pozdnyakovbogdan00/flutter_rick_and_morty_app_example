import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/presentation/widgets/person_card_widget.dart';
import '../block/person_list_cubit/person_list_cubit.dart';
import '../block/person_list_cubit/person_list_state.dart';

// 1. Превращаем виджет в StatefulWidget
class PersonsList extends StatefulWidget {
  const PersonsList({Key? key}) : super(key: key);

  @override
  State<PersonsList> createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  // 2. Все изменяемые поля переносим в State
  final scrollController = ScrollController();
  int page = -1; // Это поле теперь тоже в State

  // 3. Используем initState для инициализации
  @override
  void initState() {
    super.initState();
    setupScrollController();
  }

  // 4. Используем dispose для очистки
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          // Вызываем метод на Cubit для загрузки следующей страницы
          context.read<PersonListCubit>().loadPerson();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 5. Вызов setupScrollController убираем из build
    return BlocBuilder<PersonListCubit, PersonState>(builder: (context, state) {
      List<PersonEntity> persons = [];
      bool isLoading = false;

      if (state is PersonLoading && state.isFirstFetch) {
        return _loadingIndicator();
      } else if (state is PersonLoading) {
        persons = state.oldPersonsList;
        isLoading = true;
      } else if (state is PersonLoaded) {
        persons = state.personsList;
      } else if (state is PersonError) {
        return Center( // Оборачиваем текст в Center для лучшего вида
          child: Text(
            state.message,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        );
      }
      return ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < persons.length) {
            return PersonCard(person: persons[index]);
          } else {
            // Убираем Timer, он не нужен и может вызывать ошибки
            return _loadingIndicator();
          }
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: persons.length + (isLoading ? 1 : 0),
      );
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
