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
  }) {
    if (nome.trim().isEmpty) {
      throw ArgumentError('O nome do estudante é obrigatório.');
    }
  }
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
  }) {
    if (nome.trim().isEmpty) {
      throw ArgumentError('O nome da disciplina é obrigatório.');
    }

    if (vagasMaximas <= 0) {
      throw ArgumentError(
        'A disciplina deve possuir um número máximo de vagas maior que zero.',
      );
    }
  }
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
    final agora = DateTime.now();

    if (_inicioPeriodo == null || _fimPeriodo == null) {
      throw ArgumentError('O período de matrícula não foi configurado.');
    }
    if (agora.isBefore(_inicioPeriodo!) || agora.isAfter(_fimPeriodo!)) {
      throw ArgumentError('Fora do período oficial de matrícula.');
    }

    if (_matriculasRegistradas.contains(estudante.numeroMatricula)) {
      throw ArgumentError('O estudante já realizou a matrícula no sistema.');
    }

    if (!estudante.situacaoAtiva) {
      throw ArgumentError('Estudante inativo não pode realizar matrícula.');
    }

    if (estudante.possuiPendencia) {
      throw ArgumentError(
        'Estudante com pendências não pode efetuar novas matrículas.',
      );
    }

    if (disciplinas.length > 6) {
      throw ArgumentError(
        'O estudante pode se matricular em no máximo 6 disciplinas.',
      );
    }

    final nomesDisciplinas = disciplinas.map((d) => d.nome).toList();
    if (nomesDisciplinas.toSet().length != disciplinas.length) {
      throw ArgumentError(
        'Não é permitido se matricular na mesma disciplina mais de uma vez.',
      );
    }

    final horariosOcupados = <String>{};

    for (var disciplina in disciplinas) {
      if (disciplina.vagasPreenchidas >= disciplina.vagasMaximas) {
        throw ArgumentError(
          'A disciplina ${disciplina.nome} não possui vagas disponíveis.',
        );
      }

      if (horariosOcupados.contains(disciplina.horario)) {
        throw ArgumentError(
          'Conflito de horário detectado para a disciplina ${disciplina.nome}.',
        );
      }
      horariosOcupados.add(disciplina.horario);
    }

    for (var disciplina in disciplinas) {
      disciplina.vagasPreenchidas++;
    }

    _matriculasRegistradas.add(estudante.numeroMatricula);
  }
}
