import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reso_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatelessWidget {
  String _inputStr;
  final Function onSearchClick;
  final Function onRandomClick;
  final controller = TextEditingController();

  TriviaControls({@required this.onSearchClick, @required this.onRandomClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: Key('text_field'),
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          keyboardType: TextInputType.number,
          onSubmitted: (_) {
            getConcreteNumberTrivia();
          },
          onChanged: (value) {
            _inputStr = value;
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                key: Key('search_button'),
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: getConcreteNumberTrivia,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                key: Key('random_button'),
                child: Text('Random'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: getRandomNumberTrivia,
              ),
            ),
          ],
        )
      ],
    );
  }

  void getConcreteNumberTrivia() {
    controller.clear();
    onSearchClick(_inputStr);
  }

  void getRandomNumberTrivia() {
    controller.clear();
    onRandomClick();
  }
}
