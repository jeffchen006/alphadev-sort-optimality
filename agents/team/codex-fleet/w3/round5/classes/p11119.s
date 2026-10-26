# n=5 model=out iset=I1 prefix14_class=11119
mov S2, P3
mov S1, P0
cmp P2, P3
cmovl S2, P2
cmovg P3, P2
cmp S1, P1
cmovle S1, P1
cmovl P1, P0
cmp S1, P3
cmovle P0, P3
mov S0, S2
cmovle P3, S1
cmovle S1, P0
mov P2, P3
