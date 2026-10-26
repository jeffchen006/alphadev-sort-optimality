# n=5 model=out iset=I1 prefix14_class=3096
mov S2, P0
mov S0, P1
cmp S0, P3
cmovle P1, P3
cmovg S0, P3
cmp P2, S2
cmovl S2, P2
cmovl P2, P0
cmp S0, S2
mov P3, S0
cmovg P3, S2
mov P3, P1
cmovle S0, S2
cmp P1, P2
