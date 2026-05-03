#  Relatório – Planejamento no Mundo dos Blocos

## 1. Introdução

O problema do Mundo dos Blocos é amplamente utilizado como base para estudo de planejamento em Inteligência Artificial. Em sua forma clássica, assume-se que todos os blocos possuem dimensões unitárias e ocupam posições discretas, o que simplifica significativamente o domínio.

Neste trabalho, é proposta uma extensão desse modelo, considerando:

* blocos com dimensões variáveis
* ocupação de espaço em uma régua contínua (intervalo de 0 a 6)
* restrições físicas de estabilidade baseadas no centro geométrico

Essa abordagem torna o problema mais próximo de aplicações reais, como manipulação robótica e empilhamento físico de objetos.

---

## 2. Fundamentação Teórica

O planejamento automático utilizado neste trabalho baseia-se nos conceitos apresentados em obras clássicas da área de Inteligência Artificial, especialmente no uso de:

* Lógica de Primeira Ordem para representação do conhecimento
* Planejamento por regressão de objetivos (Goal Regression)
* Ordenação parcial de ações

A extensão do domínio tradicional exige a integração de elementos geométricos ao modelo simbólico, caracterizando um domínio híbrido.

---

## 3. Representação do Conhecimento

### 3.1 Objetos e Propriedades

Os blocos são definidos com propriedades físicas:

* `largura(bloco, valor)`
* posição inicial na régua: `pos(bloco, x)`

Cada bloco ocupa um intervalo contínuo dado por:

```
[início, início + largura]
```

---

### 3.2 Relações Espaciais

As principais relações utilizadas são:

* `sobre(X, Y)` → bloco X está sobre Y
* `pos(X, P)` → posição inicial do bloco X na régua

---

### 3.3 Centro Geométrico

O centro de um bloco é definido como:

```
centro = (início + fim) / 2
```

Essa definição é essencial para avaliação de estabilidade.

---

### 3.4 Estabilidade

A estabilidade é garantida quando o centro geométrico do bloco superior está contido dentro do intervalo do bloco inferior:

```
centro(X) ∈ intervalo(Y)
```

Essa restrição impede configurações fisicamente impossíveis.

---

## 4. Ações do Domínio

A principal ação considerada é:

### mover(bloco, destino, posição)

#### Pré-condições:

* o bloco está livre
* o destino está livre ou é a mesa
* a nova posição está dentro da régua (0 a 6)
* a configuração resultante é estável

#### Efeitos:

* atualização da relação `sobre`
* atualização da posição `pos`

---


## 5. Planejamento Automatizado

Foi implementado um planejador em Prolog baseado em busca no espaço de estados, incorporando:

* verificação de estabilidade geométrica
* restrições de posição contínua
* controle de estados visitados para evitar ciclos

O planejador gera sequências de ações válidas a partir de um estado inicial até um objetivo definido.

---

## 6. Resultados

Os testes foram realizados para três cenários distintos (Situação 1 a Situação 3).

### Observações:

* O planejador conseguiu gerar planos válidos em todos os cenários
* A inclusão da posição contínua aumentou significativamente o espaço de busca
* Restrições geométricas impediram soluções inválidas fisicamente


## 7. Discussão

A introdução de dimensões variáveis e espaço contínuo transforma o problema clássico em um domínio mais complexo.

A presença de restrições geométricas exige validações adicionais durante o planejamento, aumentando o custo computacional.

Esse tipo de modelagem é essencial para aproximar o planejamento simbólico de aplicações reais.

---

## 10. Conclusão

O trabalho demonstrou que:

* é possível estender o Mundo dos Blocos para cenários mais realistas
* a inclusão de geometria aumenta significativamente a complexidade
* planejadores automatizados são mais adequados para lidar com essas restrições

