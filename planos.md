# Plano de Teste BDD - Sistema de Matrículas

## 1. Objetivo
Validar as 12 regras de negócio (RN01–RN12) com **Testes de Valores-Limite** e **Critérios de Aceitação** em BDD (Dado/Quando/Então).

## 2. Testes de Valores-Limite (BV)

| ID | RN | Campo | Limite Testado | Resultado |
|----|----|-------|---------------|-----------|
| BV01 | RN01 | nome do estudante | vazio ("") | rejeita |
| BV02 | RN02 | número de matrícula | duplicado | rejeita |
| BV03 | RN03 | situação acadêmica | inativa (false) | rejeita |
| BV04 | RN04 | nome da disciplina | vazio ("") | rejeita |
| BV05 | RN05 | vagas máximas | zero (0) | rejeita |
| BV06 | RN06 | vagas preenchidas | igual ao máximo | rejeita |
| BV07 | RN07 | horário | conflito entre disciplinas | rejeita |
| BV08 | RN08 | quantidade de disciplinas | acima de 6 | rejeita |
| BV09 | RN09 | disciplina repetida | mesma 2x no semestre | rejeita |
| BV10 | RN10 | pendência | possui pendência | rejeita |

## 3. Critérios de Aceitação (CA)

| ID | Cenário | Dado | Quando | Então |
|----|---------|------|--------|-------|
| CA-01 | Matrícula válida | estudante ativo sem pendências + disciplina com vaga | realizarMatrícula() | vagas sobem |
| CA-02 | Pendência bloqueia | estudante com pendência financeira | realizarMatrícula() | rejeita |
| CA-03 | Disciplina lotada bloqueia | disciplina com vagas esgotadas | realizarMatrícula() | rejeita |
| CA-04 | Período bloqueia | data atual fora do período oficial | realizarMatrícula() | rejeita |
| CA-05 | Vagas atualizadas | matrícula confirmada | realizarMatrícula() | vagasPreenchidas++ |

## 4. Estratégia TDD

| Etapa | Testes | Passam | Falham |
|-------|--------|--------|--------|
| 01_red | 10 BV + 5 CA | 0 | 15 |
| 02_green | 10 BV + 5 CA | 15 | 0 |
| 03_refactor | 10 BV + 5 CA | 15 | 0 |
