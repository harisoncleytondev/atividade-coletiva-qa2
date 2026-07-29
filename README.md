# TDD - Sistema de Matrículas

Sistema de matrículas acadêmicas seguindo o ciclo TDD (Red-Green-Refactor) com 12 regras de negócio.

## Pré-requisito

- [Dart SDK](https://dart.dev/get-dart) ^3.12.0

## Etapas

### 1. RED — Escrever os testes (e falhar)

```bash
cd 01_red
dart test
```

> **15 testes falham** — as validações ainda não foram implementadas.

### 2. GREEN — Implementar e passar

```bash
cd ../02_green
dart test
```

> **15 testes passam** — todas as regras de negócio implementadas.

### 3. REFACTOR — Refatorar mantendo os testes verdes

```bash
cd ../03_refactor
dart test
```

> **15 testes passam** — código refatorado com métodos auxiliares.

## Tipos de Teste

| Tipo | Quantidade | O que valida | Exemplo |
|------|-----------|-------------|---------|
| **Valores-Limite** | 10 | Limites dos campos (vazio, zero, máximo, duplicado, inativo) | `Dado vagasMaximas = 0 → rejeita` |
| **Critérios de Aceitação** | 5 | Cenários completos de aceitação ou rejeição | `Dado estudante válido → matrícula confirmada` |

## Regras de Negócio (RN01–RN12)

| RN  | Descrição |
|-----|-----------|
| 01  | Nome do estudante é obrigatório |
| 02  | Número de matrícula deve ser único |
| 03  | Estudante deve estar com situação ativa |
| 04  | Nome da disciplina é obrigatório |
| 05  | Disciplina deve ter número máximo de vagas |
| 06  | Não matricular em disciplinas lotadas |
| 07  | Não matricular com conflito de horários |
| 08  | Máximo de 6 disciplinas por semestre |
| 09  | Não repetir mesma disciplina no semestre |
| 10  | Pendências bloqueiam nova matrícula |
| 11  | Matrícula apenas no período oficial |
| 12  | Vagas atualizadas após confirmação |

## BDD

Testes escritos em estilo BDD: `Testes de Valores-Limite / Critérios de Aceitação > CT-BV / CA > Dado/Quando/Então`.
