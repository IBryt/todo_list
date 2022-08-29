import 'package:flutter/cupertino.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/generated/l10n.dart';

class FailureHandler {
  static String getMessage(BuildContext context, Failure? failure) {
    if (failure == null) {
      return S.of(context).unexpected_error;
    }
    switch (failure.runtimeType) {
      case HiveFailure:
        return S.of(context).hive_error;
      default:
        return S.of(context).unexpected_error;
    }
  }
}
