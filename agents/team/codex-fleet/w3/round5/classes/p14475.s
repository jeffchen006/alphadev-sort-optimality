# n=5 model=out iset=I1 prefix14_class=14475
cmp P0, P3
mov S1, P3
cmovl P3, P0
cmovg S1, P0
mov S0, P1
cmp P1, P2
cmovle S0, P2
cmovg P1, P2
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
mov P3, S0
cmovl P1, S2
cmp S1, S0
