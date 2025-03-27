import 'package:equatable/equatable.dart';

abstract class ChipFieldState extends Equatable {
  const ChipFieldState();

  @override
  List<Object> get props => [];
}

class ChipFieldInitial extends ChipFieldState {}

class ChipFieldLoading extends ChipFieldState {}

class ChipFieldLoaded extends ChipFieldState {
  final List<String> users;
  final List<String> suggestions;

  const ChipFieldLoaded({required this.users, required this.suggestions});

  @override
  List<Object> get props => [users, suggestions];
}

class ChipFieldError extends ChipFieldState {
  final String message;

  const ChipFieldError(this.message);

  @override
  List<Object> get props => [message];
}
