enum TodosNomenclature { all, pending, done }

extension TodosNomenclatureExtensions on TodosNomenclature {
  String get asString {
    switch (this) {
      case TodosNomenclature.all:
        return "All";
      case TodosNomenclature.pending:
        return "Pending";
      case TodosNomenclature.done:
        return "Done";
      default:
        return "undefined";
    }
  }
}
