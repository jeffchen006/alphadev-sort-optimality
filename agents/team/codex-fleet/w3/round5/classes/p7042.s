# n=5 model=out iset=I1 prefix14_class=7042
cmp P2, P0
cmovge S0, P0
mov S1, P3
cmovg P0, P2
cmovge P2, S0
cmp S1, P1
cmovg S1, P1
cmovle P3, P1
cmp S1, P2
cmovle S2, P2
cmovl P2, S1
cmovl S1, S2
cmp P3, P0
cmovle S2, P0
