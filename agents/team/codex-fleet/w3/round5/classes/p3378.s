# n=5 model=out iset=I1 prefix14_class=3378
mov S0, P2
mov S2, P1
cmp P3, S0
cmovge S0, P3
cmovle P2, P3
cmp P0, P1
cmovl S2, P0
mov P3, S2
cmovg P1, P0
cmp P2, S2
cmovge P3, P2
cmovg P2, S2
cmp S0, P1
cmovg S2, P3
