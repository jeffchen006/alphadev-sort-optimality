# n=5 model=out iset=I1 prefix14_class=11321
cmp P0, P2
cmovl S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P1, P3
cmovle S0, P3
cmovg S0, P1
cmovg P1, P3
cmp S0, P0
mov P3, S0
cmovle S0, P0
cmovl P0, P3
cmp P2, P1
cmovg P3, P1
