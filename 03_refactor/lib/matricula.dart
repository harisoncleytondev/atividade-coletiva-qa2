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
      throw ArgumentError('A disciplina deve possuir um número máximo de vagas maior que zero.');
    }
  }

  bool get temVaga => vagasPreenchidas < vagasMaximas;
}

class SistemaMatriculas {
  static const int _limiteDisciplinas = 6;
  final List<String> _matriculasRegistradas = [];
  DateTime? _inicioPeriodo;
  DateTime? _fimPeriodo;

  void configurarPeriodoMatricula(DateTime inicio, DateTime fim) {
    _inicioPeriodo = inicio;
    _fimPeriodo = fim;
  }

  void _validarPeriodo() {
    final inicio = _inicioPeriodo;
    final fim = _fimPeriodo;
    if (inicio == null || fim == null) {
      throw ArgumentError('O período de matrícula não foi configurado.');
    }
    final agora = DateTime.now();
    if (agora.isBefore(inicio) || agora.isAfter(fim)) {
      throw ArgumentError('Fora do período oficial de matrícula.');
    }
  }

  void _validarEstudante(Estudante e) {
    if (_matriculasRegistradas.contains(e.numeroMatricula)) {
      throw ArgumentError('O estudante já realizou a matrícula no sistema.');
    }
    if (!e.situacaoAtiva) {
      throw ArgumentError('Estudante inativo não pode realizar matrícula.');
    }
    if (e.possuiPendencia) {
      throw ArgumentError('Estudante com pendências não pode efetuar novas matrículas.');
    }
  }

  void _validarDisciplinas(List<Disciplina> disciplinas) {
    if (disciplinas.length > _limiteDisciplinas) {
      throw ArgumentError('O estudante pode se matricular em no máximo $_limiteDisciplinas disciplinas.');
    }
    final nomes = <String>{};
    final horarios = <String>{};
    for (var d in disciplinas) {
      if (!d.temVaga) {
        throw ArgumentError('A disciplina ${d.nome} não possui vagas disponíveis.');
      }
      if (!nomes.add(d.nome)) {
        throw ArgumentError('Não é permitido se matricular na mesma disciplina mais de uma vez.');
      }
      if (!horarios.add(d.horario)) {
        throw ArgumentError('Conflito de horário detectado para a disciplina ${d.nome}.');
      }
    }
  }

  void _ocuparVagas(List<Disciplina> disciplinas) {
    for (var d in disciplinas) {
      d.vagasPreenchidas++;
    }
  }

  void realizarMatricula(Estudante estudante, List<Disciplina> disciplinas) {
    _validarPeriodo();
    _validarEstudante(estudante);
    _validarDisciplinas(disciplinas);
    _ocuparVagas(disciplinas);
    _matriculasRegistradas.add(estudante.numeroMatricula);
  }
}
