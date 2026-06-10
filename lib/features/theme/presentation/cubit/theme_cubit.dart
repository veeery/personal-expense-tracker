
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/theme_local_datasource.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeLocalDataSource _dataSource;

  ThemeCubit(this._dataSource)
      : super(const ThemeState(themeMode: ThemeMode.system));

  Future<void> loadTheme() async {
    final mode = await _dataSource.loadTheme();
    emit(ThemeState(themeMode: mode));
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _dataSource.saveTheme(mode);
    emit(ThemeState(themeMode: mode));
  }
}
