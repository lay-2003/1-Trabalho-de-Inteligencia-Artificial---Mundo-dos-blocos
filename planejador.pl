% ============================================================
%  PLANEJADOR DE BLOCOS COM POSICIONAMENTO EM RÉGUA/MESA
% ============================================================

:- use_module(library(heaps)).

% Tamanhos fixos conforme o enunciado
tamanho(a, 1).
tamanho(b, 1).
tamanho(c, 2).
tamanho(d, 3).

% Restringir as posições de início para evitar que os blocos saiam do limite da régua (0 a 6)
posicao_valida(a, I) :- member(I, [0, 1, 2, 3, 4, 5]).
posicao_valida(b, I) :- member(I, [0, 1, 2, 3, 4, 5]).
posicao_valida(c, I) :- member(I, [0, 1, 2, 3, 4]).
posicao_valida(d, I) :- member(I, [0, 1, 2, 3]).

% ============================================================
%  PREDICADOS DE ESTADO E FÍSICA
% ============================================================

sobreposicao(I1, F1, I2, F2) :-
    I1 < F2, I2 < F1.

% Um bloco está livre se nada estiver em cima dele
livre(Nome, Estado) :-
    \+ (member(bloco(Outro, I2, F2, Nv2, _), Estado),
        Nome \= Outro,
        member(bloco(Nome, I1, F1, Nv1, _), Estado),
        Nv2 > Nv1,
        sobreposicao(I1, F1, I2, F2)).

% Nível máximo ocupado em um intervalo [I, F]
nivel_max_em(I, F, Estado, ExclNome, NivelMax) :-
    findall(Nv, (member(bloco(N, BI, BF, Nv, _), Estado),
                 N \= ExclNome,
                 sobreposicao(I, F, BI, BF)), Niveis),
    ( Niveis = [] -> NivelMax = -1 ; max_list(Niveis, NivelMax) ).

% Verifica se há suporte suficiente para o bloco d (pode ser parcial)
tem_suporte_d(_, _, _, NivelAbaixo) :-
    NivelAbaixo =:= -1, !. % Mesa/Régua
tem_suporte_d(I, F, Estado, NivelAbaixo) :-
    member(bloco(_, BI, BF, NivelAbaixo, _), Estado),
    sobreposicao(I, F, BI, BF).

% Verifica se há suporte total para a, b, c
tem_suporte_total(_, _, _, NivelAbaixo) :-
    NivelAbaixo =:= -1, !. % Mesa/Régua
tem_suporte_total(I, F, Estado, NivelAbaixo) :-
    cobre_total(I, F, Estado, NivelAbaixo).

cobre_total(I, F, _, _) :- I >= F, !.
cobre_total(I, F, Estado, Nivel) :-
    member(bloco(_, BI, BF, Nivel, _), Estado),
    BI =< I, BF > I,
    cobre_total(BF, F, Estado, Nivel).

% Identifica os blocos que servem de suporte imediato
get_suportes(I, F, Estado, NivelAbaixo, Suportes) :-
    (NivelAbaixo =:= -1 -> Suportes = mesa ;
     findall(N, (member(bloco(N, BI, BF, NivelAbaixo, _), Estado), sobreposicao(I, F, BI, BF)), Suportes)).

% ============================================================
%  MOVIMENTO
% ============================================================

move(Estado, mover(Nome, NI, NF, DescSuporte), NovoEstado) :-
    member(bloco(Nome, VI, VF, VNv, _), Estado),
    posicao_valida(Nome, NI),
    tamanho(Nome, Tam),
    NF is NI + Tam,
    (NI \= VI), % Deve mudar de posição
    livre(Nome, Estado),
    nivel_max_em(NI, NF, Estado, Nome, NivelAbaixo),
    NovoNivel is NivelAbaixo + 1,
    % Verifica suporte
    (Nome = d -> tem_suporte_d(NI, NF, Estado, NivelAbaixo) ; tem_suporte_total(NI, NF, Estado, NivelAbaixo)),
    % Não pode colidir no mesmo nível
    \+ (member(bloco(N2, BI2, BF2, NovoNivel, _), Estado), N2 \= Nome, sobreposicao(NI, NF, BI2, BF2)),
    % Identifica o suporte para a descrição
    get_suportes(NI, NF, Estado, NivelAbaixo, Suportes),
    (Suportes = mesa -> DescSuporte = mesa ; DescSuporte = sobre(Suportes)),
    % Atualiza
    select(bloco(Nome, VI, VF, VNv, _), Estado, Resto),
    NovoEstado = [bloco(Nome, NI, NF, NovoNivel, DescSuporte) | Resto].

% ============================================================
%  BUSCA A*
% ============================================================

heuristica(Estado, EstadoFinal, H) :-
    findall(1, (member(bloco(N, I, F, _, _), Estado),
                \+ member(bloco(N, I, F, _, _), EstadoFinal)), Fora),
    length(Fora, H).

planeja(EI, EF, Plano) :-
    heuristica(EI, EF, H0),
    empty_heap(Heap0),
    add_to_heap(Heap0, H0-0, node(EI, [], 0), Heap1),
    astar(Heap1, EF, [], Plano).

astar(Heap, EF, _, Plano) :-
    get_from_heap(Heap, _-_, node(Estado, PlanoRev, _), _),
    estados_iguais(Estado, EF), !,
    reverse(PlanoRev, Plano).

astar(Heap, EF, Fechados, Plano) :-
    get_from_heap(Heap, _-_, node(Estado, PlanoRev, G), RestHeap),
    \+ estado_visitado(Estado, Fechados), !,
    findall(F-G1-node(Prox, [Mov|PlanoRev], G1),
            (move(Estado, Mov, Prox), \+ estado_visitado(Prox, Fechados),
             G1 is G + 1, heuristica(Prox, EF, H1), F is G1 + H1),
            Sucessores),
    insere_heap(Sucessores, RestHeap, NovoHeap),
    astar(NovoHeap, EF, [Estado|Fechados], Plano).

astar(Heap, EF, Fechados, Plano) :-
    get_from_heap(Heap, _, _, Rest), astar(Rest, EF, Fechados, Plano).

insere_heap([], H, H).
insere_heap([F-G-N|R], H0, H2) :- add_to_heap(H0, F-G, N, H1), insere_heap(R, H1, H2).

estados_iguais(E1, E2) :-
    forall(member(bloco(N, I, F, Nv, _), E1), member(bloco(N, I, F, Nv, _), E2)).

estado_visitado(E, [V|_]) :- estados_iguais(E, V), !.
estado_visitado(E, [_|R]) :- estado_visitado(E, R).

% ============================================================
%  SITUAÇÕES
% ============================================================

% S1
estado_inicial_s1([bloco(c,0,2,0,m), bloco(a,3,4,0,m), bloco(b,5,6,0,m), bloco(d,3,6,1,m)]).
estado_final_s1([bloco(d,3,6,0,m), bloco(a,4,5,1,m), bloco(b,5,6,1,m), bloco(c,4,6,2,m)]).

% S2
estado_inicial_s2([bloco(c,0,2,0,m), bloco(a,0,1,1,m), bloco(b,1,2,1,m), bloco(d,3,6,0,m)]).
estado_final_s2([bloco(d,3,6,0,m), bloco(c,4,6,1,m), bloco(b,5,6,2,m), bloco(a,4,5,2,m)]).

% S3
estado_inicial_s3([bloco(c,0,2,0,m), bloco(a,3,4,0,m), bloco(b,5,6,0,m), bloco(d,3,6,1,m)]).
estado_final_s3([bloco(c,0,2,0,m), bloco(a,0,1,1,m), bloco(b,1,2,1,m), bloco(d,3,6,0,m)]).

% ============================================================
%  EXECUÇÃO
% ============================================================

resolver(ID, EI, EF) :-
    format('~n--- SITUACAO ~w ---~n', [ID]),
    (planeja(EI, EF, Plano) -> imprime_plano(Plano, 1) ; write('Falha.')).

imprime_plano([], _).
imprime_plano([mover(N, I, F, Suporte)|R], Step) :-
    (Suporte = mesa -> 
        format('  ~w: mover ~w para mesa de ~w ate ~w~n', [Step, N, I, F]) ;
        Suporte = sobre(Lista),
        format('  ~w: mover ~w para cima de ~w de ~w ate ~w~n', [Step, N, Lista, I, F])
    ),
    S1 is Step + 1, imprime_plano(R, S1).

resolver_tudo :-
    estado_inicial_s1(EI1), estado_final_s1(EF1), resolver(1, EI1, EF1),
    estado_inicial_s2(EI2), estado_final_s2(EF2), resolver(2, EI2, EF2),
    estado_inicial_s3(EI3), estado_final_s3(EF3), resolver(3, EI3, EF3).

% Removida a diretiva de inicialização automática para evitar erros de permissão em alguns ambientes
% O usuário pode chamar resolver_tudo. manualmente ou via linha de comando.
