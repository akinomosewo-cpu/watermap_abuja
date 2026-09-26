import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/mock_data.dart';
import '../../domain/models/district.dart';
import '../../domain/models/repair_notice.dart';

abstract class WaterEvent extends Equatable {
  const WaterEvent();
  @override
  List<Object?> get props => [];
}

class WaterStarted extends WaterEvent {
  const WaterStarted();
}

abstract class WaterState extends Equatable {
  const WaterState();
  @override
  List<Object?> get props => [];
}

class WaterLoading extends WaterState {
  const WaterLoading();
}

class WaterLoaded extends WaterState {
  final List<District> districts;
  final List<RepairNotice> notices;

  const WaterLoaded({required this.districts, required this.notices});

  List<RepairNotice> noticesFor(String districtId) =>
      notices.where((n) => n.districtId == districtId).toList()
        ..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));

  int get districtsInOutage =>
      districts.where((d) => d.status == OutageStatus.outage).length;

  @override
  List<Object?> get props => [districts, notices];
}

/// Loads district outage status and repair notices.
///
/// Backed by [MockData] today; swap the data source here once a real API is
/// available without touching any presentation code.
class WaterBloc extends Bloc<WaterEvent, WaterState> {
  WaterBloc() : super(const WaterLoading()) {
    on<WaterStarted>((event, emit) {
      emit(WaterLoaded(
          districts: MockData.districts(), notices: MockData.repairNotices()));
    });
  }
}
