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
    if (estudante.nome.trim().isEmpty) {
      throw ArgumentError('O nome do estudante é obrigatório.');
    }

    if (_matriculasRegistradas.contains(estudante.numeroMatricula)) {
      throw ArgumentError('O número de matrícula do estudante deve ser único.');
    }

    if (!estudante.situacaoAtiva) {
      throw ArgumentError(
        'O estudante deve estar com a situação acadêmica ativa.',
      );
    }

    if (estudante.possuiPendencia) {
      throw ArgumentError(
        'Estudantes com pendências não podem efetuar novas matrículas.',
      );
    }

    if (_inicioPeriodo != null && _fimPeriodo != null) {
      final agora = DateTime.now();
      if (agora.isBefore(_inicioPeriodo!) || agora.isAfter(_fimPeriodo!)) {
        throw ArgumentError(
          'Matrícula permitida apenas durante o período oficial.',
        );
      }
    }

    for (var d in disciplinas) {
      if (d.nome.trim().isEmpty) {
        throw ArgumentError('O nome da disciplina é obrigatório.');
      }
      if (d.vagasMaximas <= 0) {
        throw ArgumentError(
          'Cada disciplina deve possuir um número máximo de vagas.',
        );
      }
    }

    for (var d in disciplinas) {
      if (d.vagasPreenchidas >= d.vagasMaximas) {
        throw ArgumentError(
          'Não é permitido matricular em disciplinas com todas as vagas preenchidas.',
        );
      }
    }

    if (disciplinas.length > 6) {
      throw ArgumentError(
        'O estudante pode se matricular em, no máximo, 6 disciplinas por semestre.',
      );
    }

    final nomes = disciplinas.map((d) => d.nome.toLowerCase()).toList();
    if (nomes.toSet().length != nomes.length) {
      throw ArgumentError(
        'O estudante não pode se matricular na mesma disciplina mais de uma vez.',
      );
    }

    final horarios = disciplinas.map((d) => d.horario).toList();
    if (horarios.toSet().length != horarios.length) {
      throw ArgumentError(
        'O estudante não pode se matricular em disciplinas com conflito de horários.',
      );
    }

    for (var d in disciplinas) {
      d.vagasPreenchidas++;
    }

    _matriculasRegistradas.add(estudante.numeroMatricula);
  }
}
