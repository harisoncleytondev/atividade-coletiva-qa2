class Estudante {
  String nome;
  String numeroMatricula;
  bool situacaoAtiva;
  bool possuiPendencia;

  Estudante({
    required this.nome,
    required this.numeroMatricula,
    required this.situacaoAtiva,
    required this.possuiPendencia,
  });
}

class Disciplina {
  String nome;
  int vagasMaximas;
  int vagasPreenchidas;
  String horario;

  Disciplina({
    required this.nome,
    required this.vagasMaximas,
    required this.vagasPreenchidas,
    required this.horario,
  });
}

class SistemaMatriculas {
  final List<String> _matriculasRegistradas = [];
  DateTime? _inicioPeriodo;
  DateTime? _fimPeriodo;

  void configurarPeriodoMatricula(DateTime inicio, DateTime fim) {
    _inicioPeriodo = inicio;
    _fimPeriodo = fim;
  }

  void realizarMatricula(Estudante estudante, List<Disciplina> disciplinas) {
    _matriculasRegistradas.add(estudante.numeroMatricula);
  }
}
