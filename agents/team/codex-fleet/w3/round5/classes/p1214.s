# n=5 model=out iset=I1 prefix14_class=1214
mov S1, P2
mov S0, P1
cmp S0, P3
cmovle P1, P3
cmovle P3, S0
cmp S1, P0
cmovl S1, P0
mov S2, P3
cmovge P2, P0
mov S0, P1
cmp P1, S1
cmovge P1, S1
cmovg S1, S0
cmp P3, P2
