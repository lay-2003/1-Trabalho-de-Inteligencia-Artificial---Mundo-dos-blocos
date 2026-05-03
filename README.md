# TrabalhoIA_MundoBlocos

## Descrição

Este repositório apresenta uma extensão do clássico problema do Mundo dos Blocos, considerando um cenário mais realista onde os blocos possuem **dimensões variáveis**, podendo ocupar espaço horizontal e vertical de forma não uniforme.

O trabalho foi desenvolvido com base nos conceitos de planejamento automático descritos em:

* Artificial Intelligence: A Modern Approach (Russell e Norvig)
* Prolog Programming for Artificial Intelligence (Bratko)

---

## Objetivo

Expandir o domínio tradicional do Mundo dos Blocos incluindo:

* Blocos com tamanhos diferentes
* Equilíbrio baseado no centro geométrico

E implementar um planejador capaz de lidar com essas novas restrições.

---

## Conteúdo do Projeto

* Representação lógica do domínio estendido
* Definição de novas propriedades e relações
* Modelagem de ações com restrições físicas
* Resolução manual de cenários
* Implementação de planejador (Goal Regression + Partial Ordering)
* Comparação entre planejamento manual e automatizado

---

## Estrutura

```
TrabalhoIA_MundoBlocos/
│
├── README.md
├── relatorio.md
├── planejador.pl
├── planejamento manual/
│   ├── situacao1.pdf
│   ├── situacao2.pdf
│   └── situacao3.pdf
```

---

##  Tecnologias Utilizadas

* Prolog
* Planejamento simbólico
* Lógica de primeira ordem

---

##  Como Executar

1. Execute:

```bash
swipl planejador.pl
```

2. Consulte um cenário:

```prolog
?- resolver_tudo.
```

---


##  Autores

1. Laysa Siqueira da Silva
2. Rebeca Agra
3. Marinaldo Júnior


