# n=5 model=out iset=I1 prefix14_class=5106
cmp P2, P0
cmovg S2, P2
cmovle S2, P0
cmovge P2, P0
mov S0, P1
cmp S0, P3
mov S1, P2
cmovge S0, P3
cmovl P1, P3
cmp S0, S1
cmovg P2, S0
cmovl S1, S0
cmp P1, S2
cmovle P3, P1
