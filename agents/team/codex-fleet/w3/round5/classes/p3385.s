# n=5 model=out iset=I1 prefix14_class=3385
mov S2, P2
cmp P3, P2
cmovle P2, P3
mov S0, P1
cmovg S2, P3
cmp P0, S0
cmovl S0, P0
cmovg P1, P0
cmp S0, P2
mov P0, P2
cmovg P0, S0
cmovg S0, P2
cmp S2, P1
cmovl P3, P1
