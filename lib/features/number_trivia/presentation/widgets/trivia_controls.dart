import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final textController = TextEditingController();
  String inputString = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField
        TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input a number',
            ),
            onChanged: (value) {
              inputString = value;
            },
            onSubmitted: (_) {
              dispatchConcrete();
            }),
        const SizedBox(height: 10),
        // Buttons
        Row(children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                dispatchConcrete();
              },
              child: const Text('Search'),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Theme.of(context).colorScheme.primaryVariant;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                dispatchRandom();
              },
              child: Text(
                'Get random trivia',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context).colorScheme.secondary;
                    }
                    return Theme.of(context).colorScheme.secondaryVariant;
                  },
                ),
              ),
            ),
          ),
        ])
      ],
    );
  }

  void dispatchConcrete() {
    if (inputString.isNotEmpty) {
      textController.clear();
      BlocProvider.of<NumberTriviaBloc>(context).add(
        GetConcreteNumberTriviaEvent(inputString),
      );
    }
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetRandomNumberTriviaEvent(),
    );
  }
}
