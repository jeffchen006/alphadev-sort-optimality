# n=5 model=out iset=I1 prefix14_class=14105
mov S1, P0
cmp P3, P0
mov S2, P1
cmovl P0, P3
cmovge S1, P3
cmp P2, P1
cmovg S2, P2
cmovle P1, P2
cmp S2, S1
mov S0, S2
cmovle S2, S1
cmovl S1, S0
cmp P0, P1
cmovg S0, P1
