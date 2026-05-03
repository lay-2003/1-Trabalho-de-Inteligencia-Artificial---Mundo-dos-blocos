
# Relatório de Desenvolvimento: Planejador de Blocos em Prolog

## 1. Introdução
Este relatório descreve o desenvolvimento de um sistema de planejamento automático para o problema do "Mundo dos Blocos", utilizando a linguagem Prolog. O desafio consistiu em organizar quatro blocos de diferentes tamanhos em uma régua com intervalo de **0 a 6**.

**Especificações dos Blocos:**
*   **Bloco A:** Tamanho 1
*   **Bloco B:** Tamanho 1
*   **Bloco C:** Tamanho 2
*   **Bloco D:** Tamanho 3

O diferencial deste projeto foi a necessidade de lidar com blocos que possuem dimensões reais e regras de equilíbrio físico, saindo do modelo tradicional onde todos os blocos são iguais.

---

## 2. Desafios e Dificuldades de Implementação

Durante o desenvolvimento, a maior dificuldade não foi encontrar a solução final, mas sim fazer a inteligência artificial "entender" as limitações físicas do mundo real. Vários problemas surgiram no processo:

### 2.1 Movimentação Sem Critério
Inicialmente, a IA apresentava uma falha grave de lógica: ela tentava mover blocos que estavam na base de uma pilha. Se o objetivo era mover o Bloco C, a IA o retirava do lugar mesmo que os blocos A e B estivessem em cima dele, ignorando completamente que o topo precisava estar livre.

### 2.2 O Fenômeno do "Desaparecimento"
Em diversas simulações, a IA simplesmente "sumia" com os blocos. Quando encontrava um conflito de espaço ou uma situação difícil de resolver, o algoritmo removia o bloco da lista em vez de movê-lo para um espaço vazio. Houve também casos de "teleportação", onde o bloco saltava de uma posição para outra sem passar pelos passos lógicos necessários.

### 2.3 Preferência por Ordem Alfabética
Um dos obstáculos mais curiosos foi a tendência da ferramenta em priorizar a ordem alfabética (A, B, C, D). A IA tentava repetidamente mover o bloco "A" apenas por ser o primeiro da lista, mesmo quando a solução óbvia exigia que o bloco "D" fosse movido primeiro para liberar o caminho. Essa "teimosia" causava travamentos e loops, onde a IA ficava movendo o bloco A para lá e para cá, sem progredir no plano real.

---

## 3. Regras de Controle e Física

Para solucionar os problemas citados, foram estabelecidas travas lógicas rigorosas no código:

*   **Verificação de Bloco Livre:** Foi implementada uma regra que impede qualquer movimento se houver um objeto sobre o bloco alvo.
*   **Apoio do Bloco D:** Por ser o maior bloco (tamanho 3), o Bloco D exige uma base sólida. Ele só pode ser movido se for para a mesa ou se houver dois blocos (como A e B) posicionados de forma a dar suporte às suas extremidades.
*   **Espaço Geométrico:** A régua de 0 a 6 é restrita. O sistema foi programado para verificar se o espaço de destino está realmente vazio, impedindo que dois blocos ocupem o mesmo intervalo de coordenadas simultaneamente.

---

## 4. Análise das Situações Resolvidas

O planejador foi capaz de resolver as três situações propostas, todas em...

---

## 5. Conclusão

O desenvolvimento deste planejador demonstrou que a lógica de programação, por si só, não compreende a física básica. Foi necessário detalhar cada restrição — desde o fato de que um bloco não pode sumir, até a regra de que não se mexe na base de uma pilha. 

A superação do viés alfabético da IA e a imposição das regras de "bloco livre" e "apoio estável" foram os pontos chave para que o sistema gerasse movimentos que são, além de logicamente corretos, fisicamente possíveis.

---
