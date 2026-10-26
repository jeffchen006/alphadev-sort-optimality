# n=5 model=out iset=I1 prefix14_class=1273
cmp P0, P1
mov S2, P0
mov S1, P3
cmovg S2, P1
cmovle P0, P1
cmovge P1, P0
cmp S1, P2
cmovl S1, P2
cmovle P2, P3
cmp P1, S1
cmovle P0, S1
cmovge P1, S1
mov S0, P1
mov S1, S2
