import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reso_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/widgets.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Number Trivia',
          key: Key('title'),
        )),
      ),
      body: SingleChildScrollView(child: buildBlocBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBlocBody(BuildContext context) {
    var numberTriviaBloc = sl<NumberTriviaBloc>();
    return BlocProvider(
      create: (BuildContext context) => numberTriviaBloc,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: "Start searching...");
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  }
                  return Container();
                },
              ),
              SizedBox(height: 20),
              TriviaControls(
                onSearchClick: (input) {
                  numberTriviaBloc.add(GetTriviaForConcreteNumber(input));
                },
                onRandomClick: () {
                  numberTriviaBloc.add(GetTriviaForRandomNumber());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
