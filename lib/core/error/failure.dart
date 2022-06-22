import 'package:equatable/equatable.dart';

abstract class Failure with EquatableMixin {
  @override
  List<Object> get props => [];
}

class HiveFailure extends Failure {}
