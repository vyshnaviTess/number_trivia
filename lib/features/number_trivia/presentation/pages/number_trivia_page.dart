import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../presentation/bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            const SizedBox(height: 10),
            // Top Half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is NumberTriviaLoading) {
                  return const LoadingWidget();
                } else if (state is NumberTriviaLoaded) {
                  return TriviaDisplay(trivia: state.trivia);
                } else if (state is NumberTriviaError) {
                  return const MessageDisplay('Error');
                } else {
                  return const MessageDisplay('Start searching!');
                }
              },
            ),
            const SizedBox(height: 20),
            // Button Half
            const TriviaControls()
          ]),
        ),
      ),
    );
  }
}
