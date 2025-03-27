import 'package:equatable/equatable.dart';

abstract class ChipFieldEvent extends Equatable {
  const ChipFieldEvent();

  @override
  List<Object> get props => [];
}

class ChipSubmitted extends ChipFieldEvent {
  final String chip;

  const ChipSubmitted(this.chip);

  @override
  List<Object> get props => [chip];
}

class ChipDeleted extends ChipFieldEvent {
  final String chip;

  const ChipDeleted(this.chip);

  @override
  List<Object> get props => [chip];
}

class SearchChanged extends ChipFieldEvent {
  final String query;

  const SearchChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SuggestionSelected extends ChipFieldEvent {
  final String suggestion;

  const SuggestionSelected(this.suggestion);

  @override
  List<Object> get props => [suggestion];
}
