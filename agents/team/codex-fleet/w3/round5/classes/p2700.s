# n=5 model=out iset=I1 prefix14_class=2700
cmp P1, P2
mov S1, P1
cmovl P1, P2
mov S0, P0
cmovg S1, P2
cmovg P2, P1
cmp S0, P3
cmovl S0, P3
cmovg P0, P3
cmp P1, S0
cmovle P1, S0
mov P1, S1
cmovg P2, S0
mov S2, P2
