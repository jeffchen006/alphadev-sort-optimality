# n=5 model=out iset=I1 prefix14_class=10322
mov S0, P2
cmp P0, P3
cmovl S1, P3
cmovle P3, P0
cmovge S1, P0
cmp P1, S0
cmovge P2, P1
cmovl S0, P1
cmp P2, S1
cmovg P1, S1
cmovg S1, P2
cmovg P2, P1
mov S1, S0
cmp S0, P3
