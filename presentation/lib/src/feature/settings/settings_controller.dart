import 'package:presentation/src/feature/controller.dart';
import 'package:presentation/src/feature/settings/settings_presenter.dart';

class SettingsController extends Controller<ViewData, SettingsPresenter> {
  final _presenter = SettingsPresenter();
  final _data = ViewData();

  @override
  SettingsPresenter get presenter => _presenter;

  @override
  ViewData get data => _data;
}
