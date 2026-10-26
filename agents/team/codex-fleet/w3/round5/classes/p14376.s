# n=5 model=out iset=I1 prefix14_class=14376
mov S0, P1
cmp P3, P1
cmovle P1, P3
mov S2, P0
cmovg S0, P3
cmp P0, P2
cmovg S2, P2
cmovg P2, P0
cmp S2, P1
cmovg P0, S2
cmovge S2, P1
cmovg P1, P0
cmp P2, S0
cmovl S2, P2
