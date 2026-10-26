# n=5 model=out iset=I1 prefix14_class=140
mov S1, P2
mov S0, P1
cmp S0, P3
cmovle P1, P3
cmovg S0, P3
cmp P0, S1
cmovl P2, P0
cmovg S1, P0
cmp P2, S0
cmovle S2, P2
cmovge S2, S0
cmovl P2, S0
mov P0, P2
mov S2, S1
