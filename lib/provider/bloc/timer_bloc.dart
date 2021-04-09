import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todoapp/main.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/ticker.dart';
part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> with HydratedMixin {
  final noteBox = Hive.box<Note>(noteBoxName);
  final int duration;
  final Ticker _ticker;
  final List<int> keys;
  final int index;
  StreamSubscription<int> _tickerSubscription;
  TimerBloc(
      {@required Ticker ticker,
      @required int this.duration,
      List<int> this.keys,
      int this.index})
      : _ticker = ticker,
        super(Ready(duration)) {
    hydrate();
  }

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is Start) {
      Start start = event;
      yield Running(start.duration);
      _tickerSubscription?.cancel();
      _tickerSubscription =
          _ticker.tick(ticks: start.duration).listen((duration) {
        add(Tick(duration: duration));
      });
    } else if (event is Pause) {
      if (state is Running) {
        _tickerSubscription.pause();
        yield Paused(state.duration);
      }
    } else if (event is Resume) {
      if (state is Paused) {
        _tickerSubscription?.resume();
        yield Running(state.duration);
      }
    } else if (event is Reset) {
      _tickerSubscription?.cancel();
      yield Ready(duration);
    } else if (event is Tick) {
      Tick tick = event;
      yield tick.duration > 0 ? Running(tick.duration) : Finished();
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  @override
  TimerState fromJson(Map<String, dynamic> json) {
    try {
      return (json['state'] as TimerState);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(TimerState state) {
    try {
      return {'state': state.toString()};
    } catch (_) {
      return null;
    }
  }
}
