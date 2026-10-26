# n=5 model=out iset=I1 prefix14_class=133
mov S1, P3
mov S0, P2
cmp S1, P1
cmovge S1, P1
cmovle P3, P1
cmp P0, S0
cmovl P2, P0
cmovg S0, P0
mov S2, S1
cmp P2, S1
cmovle S2, P2
cmovl P2, S1
mov P1, S0
cmp P3, P1
