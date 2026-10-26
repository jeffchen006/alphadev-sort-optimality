# n=3 R=4 iset=I1 model=out source=agents/enum/src/enum_out.cpp (set-model BFS, weak orders)
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovl P0, P1
cmp P0, P2
cmovl P1, P0
cmovl P0, P2
out 2, P0
cmovge P1, P2
cmp P1, S0
cmovl P1, S0
out 1, P1
cmovge P2, S0
out 0, P2
