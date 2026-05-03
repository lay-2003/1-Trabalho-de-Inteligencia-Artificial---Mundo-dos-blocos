# Relatório Técnico: Desafios na Modelagem Física e Resolução de Planejamento em Prolog

---

## 1. Introdução

O desenvolvimento de um planejador autônomo em Prolog para resolver o problema de empilhamento de blocos em uma régua/mesa revelou-se um desafio computacional e semântico de alta complexidade. O problema exigia não apenas a transição de estados lógicos, mas também a compreensão profunda de restrições físicas espaciais bidimensionais (posição horizontal e nível vertical) e regras de suporte assimétricas.

Este relatório documenta as principais dificuldades encontradas durante a modelagem do problema, os obstáculos de interpretação física enfrentados por diferentes Inteligências Artificiais (DeepSeek, ChatGPT, Gemini, BlackBoxAI e Manus) e o processo iterativo que levou à solução final bem-sucedida.

---

## 2. Dificuldades na Modelagem Física e Entendimento do Problema

A representação de problemas clássicos de blocos (como o *Blocks World*) geralmente assume que os blocos têm o mesmo tamanho e são empilhados em posições discretas e independentes. O problema proposto, no entanto, introduz variáveis contínuas discretizadas (intervalos na régua) e blocos de tamanhos variados:

- $a = 1$
- $b = 1$
- $c = 2$
- $d = 3$

Isso cria um ambiente físico significativamente mais complexo.

---

### 2.1 A Complexidade do Suporte Parcial

A maior dificuldade de entendimento físico residiu na regra de suporte do bloco $d$. Enquanto os blocos menores ($a$, $b$ e $c$) exigiam suporte total sob toda a sua base para não caírem, o bloco $d$ (tamanho 3) possuía a capacidade de se manter estável com apoio parcial.

Muitas abordagens iniciais falharam ao tentar aplicar uma regra universal de "cobertura total" para todos os blocos. Quando o bloco $d$ precisava ser movido para a posição $[0, 3]$ apoiado apenas sobre o bloco $c$ (que ocupa $[0, 2]$), a lógica estrita rejeitava o movimento, pois a posição $[2, 3]$ ficaria sem suporte.

O ponto crítico foi compreender que o modelo físico permitia suporte parcial para blocos maiores, desde que existisse apoio válido. Esse entendimento foi essencial para resolver corretamente a Situação 1 e a Situação 3.

---

### 2.2 Sobreposição e Níveis Dinâmicos

Outro desafio significativo foi o cálculo dinâmico de níveis.

Diferente de pilhas tradicionais, um bloco movido para um intervalo $[I, F]$ precisa identificar o nível mais alto ocupado por qualquer bloco que se sobreponha a esse intervalo. Isso determina a altura final do bloco após o movimento.

A detecção de colisão exigiu a implementação de uma lógica rigorosa de interseção de intervalos:

$$
I_1 < F_2 \quad \text{e} \quad I_2 < F_1
$$

Além disso, foi necessário distinguir claramente:

- Estar na mesa/régua (nível 0)
- Estar apoiado em outro bloco (nível > 0)

Isso evita estados fisicamente impossíveis, como blocos "flutuando".

---

### 2.3 Espaço de Busca e Explosão Combinatória

Com uma régua de tamanho 6 e 4 blocos de tamanhos diferentes, o número de estados possíveis cresce rapidamente.

A Situação 1, por exemplo, exige até 9 movimentos na solução manual.

Uma busca em profundidade (DFS) simples apresentou problemas como:

- Loops infinitos  
- Exploração redundante de estados  
- Não convergência  

A solução foi a utilização do algoritmo **A\*** com heurística baseada no número de blocos fora da posição final, reduzindo drasticamente o espaço de busca.

---

## 3. Análise Comparativa do Desempenho das IAs

O problema foi submetido a diferentes Inteligências Artificiais modernas:

- DeepSeek  
- ChatGPT  
- Gemini  
- Manus
- BlackBox  

O desempenho inicial foi insatisfatório na maioria dos casos, evidenciando limitações no raciocínio físico e espacial.

---

### 3.1 O Problema da “Alucinação Espacial”

As IAs conseguiram gerar código sintaticamente correto, mas falharam na modelagem física.

Erros comuns incluíram:

- Permitir sobreposição de blocos no mesmo nível  
- Exigir suporte total para todos os blocos (inclusive $d$)  
- Gerar posições fora da régua (ex: $[6,9]$)  
- Falhar na geração de planos válidos (loops ou travamentos)  

Esses problemas mostram que LLMs ainda têm dificuldade com restrições físicas não triviais.

---

### 3.2 A Abordagem do Manus AI

O Manus foi o único sistema que conseguiu chegar a uma solução funcional completa.

O diferencial foi a capacidade de:

- Executar código  
- Interpretar erros  
- Iterar automaticamente  

O processo foi iterativo:

1. **Primeira tentativa:** erro de instanciação de variáveis  
2. **Segunda tentativa:** regra incorreta de suporte para $d$  
3. **Terceira tentativa:** DFS ineficiente  
4. **Quarta tentativa:** A* funcional, mas com erros de limite  
5. **Versão final:** modelo físico correto + restrições + saída interpretável  

A capacidade de depuração foi o fator decisivo.

---

## 4. Diferença entre Planejamento Manual e Planejamento Automatizado (IA)

A diferença central entre os dois métodos está no critério de decisão e na organização das ações.

### 4.1 Ordem das Ações

O planejamento manual segue uma sequência lógica baseada em desmontagem e reconstrução da estrutura.  
O planejamento automatizado não impõe ordem fixa: as ações são escolhidas conforme reduzem o custo estimado até o objetivo, podendo antecipar ou inverter etapas.

### 4.2 Natureza do Raciocínio

- Manual: baseado em interpretação física do problema  
- Automatizado: baseado em avaliação de estados no espaço de busca  

O algoritmo não utiliza semântica, apenas compara estados com o objetivo.

### 4.3 Critério de Escolha

- Manual: decisões guiadas por intuição e simplificação  
- IA: decisões guiadas por função heurística e custo acumulado  

Isso permite que a IA selecione movimentos que não são intuitivos, mas são eficientes.

### 4.4 Soluções Geradas

O planejamento manual tende a produzir uma única sequência válida.  
A IA pode gerar múltiplos planos equivalentes, pois explora diferentes caminhos no espaço de estados.

### 4.5 Síntese

| Aspecto        | Manual            | Automatizado |
|----------------|------------------|--------------|
| Organização    | Sequencial       | Não linear   |
| Critério       | Intuição         | Heurística   |
| Flexibilidade  | Baixa            | Alta         |
| Escalabilidade | Limitada         | Elevada      |

---

## 5. Conclusão

O desenvolvimento deste planejador evidenciou que problemas com:

- raciocínio espacial  
- restrições físicas  
- variáveis contínuas discretizadas  

ainda representam desafios significativos para sistemas de IA.

Modelos tradicionais baseados apenas em geração de texto tendem a falhar em cenários complexos. Por outro lado, abordagens com execução e feedback iterativo demonstram maior robustez.

O resultado final foi um planejador:

- fisicamente consistente  
- computacionalmente eficiente  
- capaz de gerar planos válidos automaticamente  
