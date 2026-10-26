# n=5 model=out iset=I1 prefix14_class=11421
mov S1, P1
cmp P1, P0
mov S0, P2
cmovle P1, P0
cmovg S1, P0
mov S2, S1
cmp S0, P3
cmovge P2, P3
cmovge P3, S0
cmp S2, P2
cmovl S1, P2
cmovle P2, S2
cmp P1, P3
cmovge P0, P3
