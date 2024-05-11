
class RegisterState {
  bool updatePassVisibility;
  bool updateConfirmVisibility;
  bool updateRegisterLoading;

  bool updateUserImage;
  bool updateComRegisterLoading;

  RegisterState({
    this.updatePassVisibility = false,
    this.updateConfirmVisibility = false,
    this.updateRegisterLoading = false,
    this.updateUserImage = false,
    this.updateComRegisterLoading = false
  });
}

