extension TitleString on String {
  String toTitleString() {
    return this[0].toUpperCase() + substring(1);
  }
}
