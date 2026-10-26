# n=5 model=out iset=I1 prefix14_class=2307
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmovge S2, P2
mov S1, P0
cmp S1, P3
cmovg P0, P3
cmovl S1, P3
cmovge P3, S1
cmp S1, P1
cmovle P3, P1
cmovl P1, S1
cmp P0, S2
cmovge S0, S2
