# n=3 R=4 iset=I1 model=out source=agents/enum/src/enum_out.cpp (set-model BFS, weak orders)
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P0, P2
cmovg S0, P0
cmovle S0, P2
out 2, S0
cmovg P0, P2
cmp P0, P1
cmovge P2, P1
out 0, P2
cmovg P1, P0
out 1, P1
