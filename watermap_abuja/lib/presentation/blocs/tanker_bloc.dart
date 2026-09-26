import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/mock_data.dart';
import '../../domain/models/tanker.dart';

abstract class TankerEvent extends Equatable {
  const TankerEvent();
  @override
  List<Object?> get props => [];
}

class TankerStarted extends TankerEvent {
  const TankerStarted();
}

class TankerState extends Equatable {
  final List<Tanker> tankers;
  final bool loading;

  const TankerState({this.tankers = const [], this.loading = true});

  List<Tanker> forDistrict(String districtId) =>
      tankers.where((t) => t.districtId == districtId).toList()
        ..sort((a, b) => a.pricePerTrip.compareTo(b.pricePerTrip));

  TankerState copyWith({List<Tanker>? tankers, bool? loading}) =>
      TankerState(tankers: tankers ?? this.tankers, loading: loading ?? this.loading);

  @override
  List<Object?> get props => [tankers, loading];
}

class TankerBloc extends Bloc<TankerEvent, TankerState> {
  TankerBloc() : super(const TankerState()) {
    on<TankerStarted>((event, emit) {
      emit(TankerState(tankers: MockData.tankers(), loading: false));
    });
  }
}
