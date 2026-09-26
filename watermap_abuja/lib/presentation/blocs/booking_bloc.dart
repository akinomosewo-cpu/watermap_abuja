import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/booking.dart';
import '../../domain/models/tanker.dart';
import '../../domain/services/booking_service.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

/// Book a tanker, optionally splitting the cost across [flatLabels].
/// Pass matching [weights] (e.g. occupant counts) to split unevenly instead
/// of splitting the total evenly across flats.
class TankerBooked extends BookingEvent {
  final Tanker tanker;
  final List<String> flatLabels;
  final List<double>? weights;

  const TankerBooked(this.tanker, {this.flatLabels = const [], this.weights});

  @override
  List<Object?> get props => [tanker, flatLabels, weights];
}

class BookingStatusChanged extends BookingEvent {
  final String bookingId;
  final BookingStatus status;
  const BookingStatusChanged(this.bookingId, this.status);
  @override
  List<Object?> get props => [bookingId, status];
}

class BookingState extends Equatable {
  final List<Booking> history;
  const BookingState({this.history = const []});

  List<Booking> get sortedByRecent =>
      [...history]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  double get totalCommissionEarned => history.fold(
      0,
      (sum, b) =>
          sum + (b.status == BookingStatus.cancelled ? 0 : b.commissionAmount));

  @override
  List<Object?> get props => [history];
}

/// Tracks tanker bookings and the resulting order history. Cost-splitting
/// math itself lives in [BookingService] / `CostSplitter` so it can be unit
/// tested without spinning up Bloc/Flutter.
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(const BookingState()) {
    on<TankerBooked>((event, emit) {
      final booking = BookingService.createBooking(
        tanker: event.tanker,
        flatLabels: event.flatLabels,
        weights: event.weights,
      );
      emit(BookingState(history: [...state.history, booking]));
    });

    on<BookingStatusChanged>((event, emit) {
      emit(BookingState(
        history: state.history
            .map((b) =>
                b.id == event.bookingId ? b.copyWith(status: event.status) : b)
            .toList(),
      ));
    });
  }
}
