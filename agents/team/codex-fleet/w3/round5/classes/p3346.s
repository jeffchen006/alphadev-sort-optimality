# n=5 model=out iset=I1 prefix14_class=3346
mov S0, P3
cmp P0, P1
mov S1, P1
cmovg P1, P0
cmovl S1, P0
cmp P2, S0
cmovge P3, P2
cmovl S0, P2
cmp S0, S1
cmovge S2, S1
cmovg S1, S0
cmovl S2, S0
cmp P1, P3
cmovle P0, P1
