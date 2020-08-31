import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:presentation/src/feature/presenter.dart';

abstract class Controller<D extends ViewData, P extends Presenter> {
  P get presenter;
  D get data;

  BuildContext context;
  Function(VoidCallback) setState;

  List<ReactionDisposer> _reactions = List();
  List<Timer> _timers = List();

  init(BuildContext context, Function(VoidCallback) setState) {
    this.context = context;
    this.setState = setState;
  }

  dispose() {
    _reactions.forEach((reaction) => reaction?.call());
    _reactions.clear();
    _timers.forEach((timer) => timer?.cancel());
    _timers.clear();
    presenter?.dispose();
    context = null;
    setState = null;
  }

  runDelayed(Duration duration, Function callback) {
    Timer timer = Timer(duration, callback);
    _timers.add(timer);
  }

  observe(
    RequestResult Function(Reaction) observable, {
    Function(dynamic) onSuccess,
    Function onLoading,
    Function(dynamic) onError,
  }) {
    ReactionDisposer reactionDisposer = reaction<RequestResult>(
      observable,
      (result) {
        if (result.isLoading()) {
          onLoading?.call();
        } else if (result.isSuccess()) {
          onSuccess?.call(result.data);
        } else if (result.isError()) {
          onError?.call(result.error);
        }
      },
    );
    _reactions.add(reactionDisposer);
  }
}

class ViewData {}
