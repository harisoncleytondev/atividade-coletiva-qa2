import 'package:sistema_matriculas/matricula.dart';
import 'package:test/test.dart';

void main() {
  group('Testes de Valores-Limite', () {
    group('CT-BV01 (RN01): Nome do estudante no limite vazio', () {
      test('Dado nome vazio Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: '', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        expect(() => sistema.realizarMatricula(e, []), throwsArgumentError);
      });
    });

    group('CT-BV02 (RN02): Matrícula duplicada', () {
      test('Dado número já registrado Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e1 = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final e2 = Estudante(nome: 'Maria', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        sistema.realizarMatricula(e1, []);
        expect(() => sistema.realizarMatricula(e2, []), throwsArgumentError);
      });
    });

    group('CT-BV03 (RN03): Situação acadêmica no limite inativo', () {
      test('Dado estudante inativo Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: false, possuiPendencia: false);
        expect(() => sistema.realizarMatricula(e, []), throwsArgumentError);
      });
    });

    group('CT-BV04 (RN04): Nome da disciplina no limite vazio', () {
      test('Dado disciplina sem nome Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d = Disciplina(nome: '', vagasMaximas: 40, vagasPreenchidas: 0, horario: 'SEG 08:00');
        expect(() => sistema.realizarMatricula(e, [d]), throwsArgumentError);
      });
    });

    group('CT-BV05 (RN05): Vagas máximas no limite zero', () {
      test('Dado vagasMaximas = 0 Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d = Disciplina(nome: 'Matemática', vagasMaximas: 0, vagasPreenchidas: 0, horario: 'SEG 08:00');
        expect(() => sistema.realizarMatricula(e, [d]), throwsArgumentError);
      });
    });

    group('CT-BV06 (RN06): Vagas preenchidas no limite máximo', () {
      test('Dado vagas esgotadas Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d = Disciplina(nome: 'Matemática', vagasMaximas: 40, vagasPreenchidas: 40, horario: 'SEG 08:00');
        expect(() => sistema.realizarMatricula(e, [d]), throwsArgumentError);
      });
    });

    group('CT-BV07 (RN07): Conflito de horário', () {
      test('Dado disciplinas com mesmo horário Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d1 = Disciplina(nome: 'Matemática', vagasMaximas: 40, vagasPreenchidas: 10, horario: 'SEG 08:00');
        final d2 = Disciplina(nome: 'Física', vagasMaximas: 40, vagasPreenchidas: 10, horario: 'SEG 08:00');
        expect(() => sistema.realizarMatricula(e, [d1, d2]), throwsArgumentError);
      });
    });

    group('CT-BV08 (RN08): Quantidade de disciplinas acima do limite', () {
      test('Dado 7 disciplinas Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final disciplinas = List.generate(7, (i) => Disciplina(
          nome: 'D$i', vagasMaximas: 40, vagasPreenchidas: 0, horario: '${i % 5} 08:00',
        ));
        expect(() => sistema.realizarMatricula(e, disciplinas), throwsArgumentError);
      });
    });

    group('CT-BV09 (RN09): Disciplina repetida no mesmo semestre', () {
      test('Dado mesma disciplina 2 vezes Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d1 = Disciplina(nome: 'Matemática', vagasMaximas: 40, vagasPreenchidas: 10, horario: 'SEG 08:00');
        final d2 = Disciplina(nome: 'Matemática', vagasMaximas: 40, vagasPreenchidas: 10, horario: 'QUA 08:00');
        expect(() => sistema.realizarMatricula(e, [d1, d2]), throwsArgumentError);
      });
    });

    group('CT-BV10 (RN10): Pendência acadêmica/financeira', () {
      test('Dado estudante com pendência Quando realizar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: true);
        expect(() => sistema.realizarMatricula(e, []), throwsArgumentError);
      });
    });
  });

  group('Critérios de Aceitação', () {
    group('CA-01: Matrícula bem-sucedida de estudante válido', () {
      test('Dado estudante ativo sem pendências e disciplina com vaga Quando realizar matrícula Então matrícula é confirmada', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d = Disciplina(nome: 'Matemática', vagasMaximas: 40, vagasPreenchidas: 10, horario: 'SEG 08:00');
        sistema.realizarMatricula(e, [d]);
        expect(d.vagasPreenchidas, equals(11));
      });
    });

    group('CA-02 (RN10): Matrícula rejeitada por pendência', () {
      test('Dado estudante com pendência financeira Quando tentar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: true);
        expect(() => sistema.realizarMatricula(e, []), throwsArgumentError);
      });
    });

    group('CA-03 (RN06): Matrícula rejeitada por disciplina lotada', () {
      test('Dado disciplina com todas as vagas preenchidas Quando tentar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d = Disciplina(nome: 'Matemática', vagasMaximas: 40, vagasPreenchidas: 40, horario: 'SEG 08:00');
        expect(() => sistema.realizarMatricula(e, [d]), throwsArgumentError);
      });
    });

    group('CA-04 (RN11): Matrícula rejeitada fora do período', () {
      test('Dado data atual fora do período oficial Quando tentar matrícula Então sistema rejeita', () {
        final sistema = SistemaMatriculas();
        sistema.configurarPeriodoMatricula(DateTime(2024, 1, 1), DateTime(2024, 1, 31));
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        expect(() => sistema.realizarMatricula(e, []), throwsArgumentError);
      });
    });

    group('CA-05 (RN12): Vagas atualizadas após confirmação', () {
      test('Dado matrícula confirmada com sucesso Quando realizar matrícula Então vagasPreenchidas incrementa', () {
        final sistema = SistemaMatriculas();
        final e = Estudante(nome: 'João', numeroMatricula: '2024001', situacaoAtiva: true, possuiPendencia: false);
        final d = Disciplina(nome: 'Matemática', vagasMaximas: 40, vagasPreenchidas: 10, horario: 'SEG 08:00');
        sistema.realizarMatricula(e, [d]);
        expect(d.vagasPreenchidas, equals(11));
      });
    });
  });
}
