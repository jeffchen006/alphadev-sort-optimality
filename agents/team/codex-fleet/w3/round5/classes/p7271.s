# n=5 model=out iset=I1 prefix14_class=7271
cmp P3, P1
mov S0, P2
cmovl S2, P3
cmovl P3, P1
cmovl P1, S2
cmp P0, S0
cmovle S0, P0
cmovle P0, P2
cmp S0, P1
cmovg S1, P1
cmovle S1, S0
cmovge P1, S0
cmp P3, P0
cmovle S1, P0
