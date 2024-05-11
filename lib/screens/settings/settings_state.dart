
class SettingsState {
  bool updateUserData;
  bool updateHistoryEnabling;
  bool updateHistoryAccess;

  SettingsState({
    this.updateUserData = false,
    this.updateHistoryEnabling = false,
    this.updateHistoryAccess = false
  });
}
