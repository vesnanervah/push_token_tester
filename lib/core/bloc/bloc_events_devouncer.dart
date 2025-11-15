import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

EventTransformer<E> debounceTransformer<E>(Duration duration) =>
    (events, mapper) => events.debounceTime(duration).flatMap(mapper);
