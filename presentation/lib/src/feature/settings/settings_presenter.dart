import 'package:mobx/mobx.dart';
import 'package:presentation/src/feature/presenter.dart';

part 'settings_presenter.g.dart';

class SettingsPresenter = SettingsPresenterBase with _$SettingsPresenter;

abstract class SettingsPresenterBase extends Presenter with Store {}
