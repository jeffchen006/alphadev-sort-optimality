# n=5 model=out iset=I1 prefix14_class=5426
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
cmovge P3, S1
cmp P1, P2
mov S2, P1
cmovl S2, P2
cmovge P1, P2
mov S0, P1
cmp P1, P3
cmovg S0, P3
cmovg P3, P1
cmp S2, P0
cmovle P1, S2
