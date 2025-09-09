mixin ValidatingTaskInformation {
  void textNotIsNull(String? text, {String? error}){
    if(text is String){
      if(text.replaceAll(RegExp(r'\s+'), '').isEmpty) throw Exception(error ?? "O valor não pode ser vazio");
    }
  }

  void dataTimeNotIsNull(DateTime? content, {String? error}){
    if(content is! DateTime){
      throw Exception(error ?? "A data  não pode ser nula");
    }
  }

  void boolNotIsNull(bool? content, {String? error}){
    if(content is! bool){
      throw Exception(error ?? "O valor não pode ser vazio");
    }
  }
  void textIsLessThan20Characters(String text, {String? error}){
    if(text.length > 20) throw Exception(error ?? "O valor não pode ter mais de 20 caracteres");
  }

}