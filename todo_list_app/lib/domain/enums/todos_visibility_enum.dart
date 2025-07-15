enum TodosVisibility { all, pending, done }

extension TodosVisibilityExtensions on TodosVisibility {
  String get asString {
    switch (this) {
      case TodosVisibility.all:
        return "All";
      case TodosVisibility.pending:
        return "Pending";
      case TodosVisibility.done:
        return "Done";
      default:
        return "undefined";
    }
  }
}
