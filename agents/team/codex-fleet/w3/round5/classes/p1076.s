# n=5 model=out iset=I1 prefix14_class=1076
cmp P1, P3
mov S2, P1
cmovl S2, P3
mov S0, P2
cmovl P3, P1
cmp P2, P0
cmovg S0, P0
cmovg P0, P2
cmovle P2, P0
cmp P0, S2
cmovg P2, S2
cmovg S2, P0
mov P0, P3
cmp S0, P3
