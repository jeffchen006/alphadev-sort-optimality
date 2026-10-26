# n=5 model=out iset=I1 prefix14_class=13455
cmp P1, P3
cmovg S2, P1
cmovle S2, P3
cmovl P3, P1
cmp P0, P2
cmovl S1, P0
cmovle P0, P2
cmovl P2, S1
mov S0, P2
cmp S0, P3
cmovl S0, P3
cmovl P3, P2
mov P2, S0
mov P3, S2
