import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Type call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
