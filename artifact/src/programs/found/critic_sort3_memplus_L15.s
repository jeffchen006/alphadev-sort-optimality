# n=3 R=6 iset=I1 model=memplus source=critic/bf_mm.cpp (agents/critic/logs/mm_n3_memplus_I1.log, first L=15 SAT) L=15 (every instruction counts; P = memory cells)
mov S0, P0
mov S1, P0
mov S2, P1
cmp S0, P2
cmovl S0, P2
cmovg S1, P2
cmp S0, S2
cmovl S2, S0
cmovl S0, P1
mov P2, S0
cmp S1, S2
cmovg S2, S1
cmovg S1, P1
mov P0, S1
mov P1, S2
