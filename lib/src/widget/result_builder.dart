import 'package:flutter/material.dart';

import '../notifier/result.dart';

class ResultBuilder<V, E> extends StatelessWidget {
  const ResultBuilder({
    Key? key,
    required this.result,
    required this.onError,
    required this.onData,
    required this.onLoading,
  }) : super(key: key);

  final Result<V, E> Function(BuildContext) result;
  final Widget Function(BuildContext, E) onError;
  final Widget Function(BuildContext, V) onData;
  final Widget Function(BuildContext) onLoading;

  @override
  @override
  Widget build(BuildContext context) {
    final r = result(context);

    final error = r.error;
    if (error != null) {
      return onError(context, error);
    }

    final storyIds = r.value;
    if (storyIds != null) {
      return onData(context, storyIds);
    }

    return onLoading(context);
  }
}
