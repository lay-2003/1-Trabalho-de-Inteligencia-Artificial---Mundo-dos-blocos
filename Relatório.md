# 📘 Relatório Técnico  
## Planejamento no Mundo dos Blocos com Dimensões Variáveis


## 1. Introdução

O desenvolvimento de um planejador autônomo em Prolog para resolver o problema de empilhamento de blocos em uma régua revelou-se um desafio significativamente mais complexo do que o problema clássico conhecido como *Blocks World*.

Diferentemente do modelo tradicional, onde todos os blocos possuem o mesmo tamanho e ocupam posições discretas independentes, o cenário proposto introduz características adicionais que aumentam substancialmente a complexidade do problema, como:

- blocos com dimensões diferentes  
- ocupação de intervalos na régua  
- restrições geométricas reais  
- dependência de suporte físico  

Nesse contexto, o problema deixa de ser apenas simbólico e passa a envolver também raciocínio espacial e físico. Cada ação executada deve não apenas levar o sistema mais próximo do objetivo, mas também garantir que o estado resultante seja fisicamente válido.

Assim, o desenvolvimento da solução exigiu não apenas conhecimento em planejamento automático, mas também uma modelagem cuidadosa das restrições do ambiente.

---

## 2. Modelagem do Problema

### 2.1 Blocos e Dimensões

| Bloco | Tamanho |
|------|--------|
| a    | 1      |
| b    | 1      |
| c    | 2      |
| d    | 3      |

---

### 2.2 Régua

A régua possui posições de 0 a 6:

$$0 ─── 1 ─── 2 ─── 3 ─── 4 ─── 5 ─── 6$$

Cada bloco ocupa um intervalo contínuo:

- `a`: (x, x+1)  
- `b`: (x, x+1)  
- `c`: (x, x+2)  
- `d`: (x, x+3)  

---

## 3. Dificuldades na Modelagem Física

### 3.1 Suporte Parcial

Uma das principais dificuldades foi a definição correta das regras de suporte entre os blocos.

Inicialmente, foi assumido que todos os blocos precisariam de suporte total sob toda a sua base. No entanto, essa abordagem se mostrou incorreta ao analisar o comportamento do bloco `d`, que possui maior dimensão.

#### Exemplo do problema:
$c: [0–2]$

$d: [0–3]$

Nesse caso, parte de `d` não estaria apoiada sobre `c`. Um modelo rígido rejeitaria esse estado, mas o cenário proposto permite suporte parcial para blocos maiores.

#### Conclusão:

- blocos menores → exigem suporte completo  
- blocos maiores → podem ter suporte parcial  

Essa distinção foi essencial para corrigir a modelagem e permitir a geração de planos válidos.

---

### 3.2 Sobreposição de Intervalos

Para garantir que blocos não ocupem o mesmo espaço indevidamente, foi necessário implementar uma verificação de interseção de intervalos.

A condição utilizada foi:

$$ I_1 < F_2 \quad \text{e} \quad I_2 < F_1 $$

Essa regra permite identificar quando dois blocos:

- se sobrepõem  
- podem servir de suporte  
- entram em colisão  

---

### 3.3 Níveis Dinâmicos

Outro desafio importante foi o cálculo do nível (altura) dos blocos.

Diferente do modelo clássico, o nível não é fixo. Ele depende da altura máxima dos blocos que ocupam a região de destino.

#### Exemplo:
Região destino: 
$[4–6]$

Se existir:
`c` no nível 1 e `d` no nível 0 → novo bloco será colocado no nível 2

Sem esse cálculo, o sistema pode gerar estados inválidos, como:

- blocos flutuando  
- blocos atravessando outros  

---

### 3.4 Explosão Combinatória

Com múltiplos blocos e várias posições possíveis, o espaço de estados cresce rapidamente.

Problemas encontrados com busca em profundidade $(DFS)$:

- loops infinitos  
- repetição de estados  
- baixa eficiência  

#### Solução adotada:

Uso do algoritmo **A\*** com heurística baseada em:

> número de blocos fora da posição final

Isso permitiu:

- reduzir o espaço de busca  
- melhorar a eficiência  
- evitar caminhos desnecessários  

---

## 4. Situação 2 – Planejamento Manual


### Estado Inicial (S0)
Região 0–2:

$a$ $b$

$c$

Região 3–6:

$d$


Representação:

- `a` e `b` estão sobre `c`
- `c`: ocupa (0–2)
- `d`: ocupa (3–6)

---

### Estado Objetivo (S5)
   $a$  $b$
  
   $c$
   
   $d$

   
Intervalos desejados:

- `a`: (4–5)  
- `b`: (5–6)  
- `c`: (4–6)  
- `d`: (3–6)  

---

## Plano de Ações

### Passo 1

Remover `a` de cima de `c`:

$move(a, c → mesa[0–1])$


### Passo 2

Remover `b`:

$move(b, c → mesa[2–3])$


### Estado intermediário
$a: [0–1]$

$b: [2–3]$

$c: [0–2]$

$d: [3–6]$


### Passo 3

Mover `c` para cima de `d`:

$move(c, mesa → d[4–6])$


### Passo 4

Mover `a`:

$move(a, mesa → c[4–5])$


### Passo 5

Mover `b`:

$move(b, mesa → c[5–6])$


### Estado Final
$a: [4–5]$

$b: [5–6]$

$c: [4–6]$

$d: [3–6]$


Objetivo alcançado com sucesso.

---

## 5. Análise das Inteligências Artificiais

Durante o desenvolvimento, diversas IAs foram utilizadas como apoio:

- ChatGPT  
- Gemini  
- DeepSeek  
- Manus  
- BlackBox  

---

### Problema: “Alucinação Espacial”

As IAs apresentaram dificuldades na modelagem física, gerando erros como:

- sobreposição inválida de blocos  
- posições fora da régua  
- suporte incorreto  
- planos inconsistentes  

Isso evidencia limitações no raciocínio espacial.

---

### Destaque: Manus

O Manus se destacou por sua capacidade de:

- executar código  
- detectar erros  
- iterar automaticamente  

Processo observado:

1. erro de variáveis  
2. erro de suporte  
3. busca ineficiente  
4. ajuste com A*  
5. solução final correta  

---

## 6. Planejamento Manual vs Automatizado

| Aspecto        | Manual            | IA |
|----------------|------------------|----|
| Organização    | Sequencial       | Não linear |
| Decisão        | Intuição         | Heurística |
| Flexibilidade  | Baixa            | Alta |
| Escalabilidade | Limitada         | Alta |

---

## 7. Conclusão

O desenvolvimento deste trabalho evidenciou que a modelagem de problemas envolvendo restrições físicas e raciocínio espacial exige um nível de detalhamento significativamente maior do que aquele normalmente empregado em problemas clássicos de planejamento. A introdução de blocos com diferentes dimensões e a necessidade de representar intervalos contínuos na régua tornaram o problema mais próximo de cenários reais, onde fatores como suporte, estabilidade e ocupação espacial precisam ser rigorosamente considerados.

Ao longo do processo, ficou evidente que abordagens baseadas apenas em manipulação simbólica não são suficientes para capturar toda a complexidade do ambiente. A dificuldade enfrentada por diferentes sistemas de Inteligência Artificial em produzir soluções fisicamente válidas demonstra que ainda existem limitações importantes no tratamento de restrições espaciais mais sofisticadas.

Por outro lado, métodos que combinam geração de soluções com execução e validação iterativa mostraram-se mais eficazes, pois permitem identificar inconsistências e refinar progressivamente o modelo. Esse processo contribui para a construção de soluções mais robustas e confiáveis.

O resultado final foi um planejador capaz de representar corretamente o ambiente e gerar planos válidos respeitando todas as restrições impostas, demonstrando a importância de uma modelagem cuidadosa em problemas de planejamento em Inteligência Artificial.
