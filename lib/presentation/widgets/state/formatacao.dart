String formatMatricula(String matricula) {
  // Remove qualquer caractere que não seja número
  final digitsOnly = matricula.replaceAll(RegExp(r'\D'), '');

  if (digitsOnly.length != 9) {
    // Caso o tamanho seja diferente de 9, retorna original
    return matricula;
  }

  // Formata como 33.333.333-3
  final part1 = digitsOnly.substring(0, 2);
  final part2 = digitsOnly.substring(2, 5);
  final part3 = digitsOnly.substring(5, 8);
  final part4 = digitsOnly.substring(8);

  return '$part1.$part2.$part3-$part4';
}


String? formatCpf(String? cpf) {
  // Remove tudo que não for número
  final digitsOnly = cpf?.replaceAll(RegExp(r'\D'), '');

  if (digitsOnly?.length != 11) {
    // Se não tiver 11 dígitos, retorna original
    return cpf;
  }

  final part1 = digitsOnly?.substring(0, 3);
  final part2 = digitsOnly?.substring(3, 6);
  final part3 = digitsOnly?.substring(6, 9);
  final part4 = digitsOnly?.substring(9);

  return '$part1.$part2.$part3-$part4';
}
