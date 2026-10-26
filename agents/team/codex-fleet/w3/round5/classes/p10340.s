# n=5 model=out iset=I1 prefix14_class=10340
cmp P1, P0
mov S0, P0
cmovg S0, P1
cmovl P0, P1
mov P1, P3
cmp P1, P2
cmovle P3, P2
cmovg P1, P2
mov P2, P0
cmp S0, P3
cmovg S2, P3
cmovg P3, S0
cmovg S0, S2
cmp P2, P1
