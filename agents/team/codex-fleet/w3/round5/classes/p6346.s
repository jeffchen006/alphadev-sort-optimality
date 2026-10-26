# n=5 model=out iset=I1 prefix14_class=6346
cmp P3, P2
cmovge S0, P3
cmovge P3, P2
cmovg P2, S0
cmp P0, P1
mov S2, P2
cmovle S1, P1
cmovl P1, P0
cmovg S1, P0
cmp S1, S2
cmovg P2, S1
cmovl S2, S1
cmp P1, P3
cmovle P0, P1
