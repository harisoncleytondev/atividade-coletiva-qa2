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

  bool get valido => nome.trim().isNotEmpty && situacaoAtiva && !possuiPendencia;
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

  bool get nomeValido => nome.trim().isNotEmpty;
  bool get vagasValidas => vagasMaximas > 0;
  bool get temVaga => vagasPreenchidas < vagasMaximas;
}

class SistemaMatriculas {
  final List<String> _matriculasRegistradas = [];
  DateTime? _inicioPeriodo;
  DateTime? _fimPeriodo;

  void configurarPeriodoMatricula(DateTime inicio, DateTime fim) {
    _inicioPeriodo = inicio;
    _fimPeriodo = fim;
  }

  void _validarEstudante(Estudante e) {
    if (e.nome.trim().isEmpty) throw ArgumentError('O nome do estudante é obrigatório.');
    if (_matriculasRegistradas.contains(e.numeroMatricula)) {
      throw ArgumentError('O número de matrícula do estudante deve ser único.');
    }
    if (!e.situacaoAtiva) throw ArgumentError('O estudante deve estar com a situação acadêmica ativa.');
    if (e.possuiPendencia) throw ArgumentError('Estudantes com pendências não podem efetuar novas matrículas.');
  }

  void _validarPeriodo() {
    if (_inicioPeriodo != null && _fimPeriodo != null) {
      final agora = DateTime.now();
      if (agora.isBefore(_inicioPeriodo!) || agora.isAfter(_fimPeriodo!)) {
        throw ArgumentError('Matrícula permitida apenas durante o período oficial.');
      }
    }
  }

  void _validarDisciplinas(List<Disciplina> disciplinas) {
    if (disciplinas.length > 6) {
      throw ArgumentError('O estudante pode se matricular em, no máximo, 6 disciplinas por semestre.');
    }
    for (var d in disciplinas) {
      if (!d.nomeValido) throw ArgumentError('O nome da disciplina é obrigatório.');
      if (!d.vagasValidas) throw ArgumentError('Cada disciplina deve possuir um número máximo de vagas.');
    }
    for (var d in disciplinas) {
      if (!d.temVaga) {
        throw ArgumentError('Não é permitido matricular em disciplinas com todas as vagas preenchidas.');
      }
    }
    final nomes = disciplinas.map((d) => d.nome.toLowerCase()).toList();
    if (nomes.toSet().length != nomes.length) {
      throw ArgumentError('O estudante não pode se matricular na mesma disciplina mais de uma vez.');
    }
    final horarios = disciplinas.map((d) => d.horario).toList();
    if (horarios.toSet().length != horarios.length) {
      throw ArgumentError('O estudante não pode se matricular em disciplinas com conflito de horários.');
    }
  }

  void _ocuparVagas(List<Disciplina> disciplinas) {
    for (var d in disciplinas) {
      d.vagasPreenchidas++;
    }
  }

  void realizarMatricula(Estudante estudante, List<Disciplina> disciplinas) {
    _validarEstudante(estudante);
    _validarPeriodo();
    _validarDisciplinas(disciplinas);
    _ocuparVagas(disciplinas);
    _matriculasRegistradas.add(estudante.numeroMatricula);
  }
}
