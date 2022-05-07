import 'package:flutter/material.dart';

import '../constants/style/dimens.dart';

class SomethingWentWrong extends StatelessWidget {
  final String message;
  final void Function()? onPressed;

  const SomethingWentWrong({
    Key? key,
    required this.message,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Oops, something went wrong...',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Dimens.baselineGrid / 2),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Dimens.baselineGrid),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
