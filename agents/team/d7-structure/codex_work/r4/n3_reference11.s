# n=3 iset=I1 model=out k=11
cmp P2, P1
mov S0, P1
cmovl S0, P2
cmovg P1, P2
cmp P1, P0
mov S1, P0
cmovl S1, P1
cmovle P1, P0
cmp S0, S1
cmovle P0, S0
cmovg S1, S0
out 0, P0
out 1, S1
out 2, P1
