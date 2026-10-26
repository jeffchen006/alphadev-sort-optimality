# n=5 model=out iset=I1 prefix14_class=11306
mov S2, P0
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmovl P0, S2
cmp P1, P2
cmovle S0, P1
cmovl P1, P2
cmovl P2, S0
cmp S2, P1
cmovl P0, P1
cmovg S2, P1
mov P0, P3
cmp P2, P0
