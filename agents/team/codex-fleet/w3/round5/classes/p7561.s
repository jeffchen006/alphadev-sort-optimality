# n=5 model=out iset=I1 prefix14_class=7561
mov S0, P2
cmp S0, P0
cmovg S0, P0
mov S1, P3
cmovg P0, P2
cmp P3, P1
cmovle P3, P1
mov P2, P3
cmovg S1, P1
cmp S1, S0
cmovl P1, S1
cmovl S1, S0
cmovl S0, P1
cmp P0, P3
