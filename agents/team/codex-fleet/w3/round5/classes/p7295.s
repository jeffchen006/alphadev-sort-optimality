# n=5 model=out iset=I1 prefix14_class=7295
cmp P1, P3
mov S1, P2
cmovle S2, P3
cmovge S2, P1
cmovl P3, P1
cmp P0, P2
cmovl P2, P0
cmovle P0, S1
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovg P2, S0
cmp P0, S2
cmovl S1, S2
