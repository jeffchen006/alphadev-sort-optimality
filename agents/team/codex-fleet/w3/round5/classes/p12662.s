# n=5 model=out iset=I1 prefix14_class=12662
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
cmovge S2, P3
cmp P1, P0
mov S1, P2
mov S0, S2
cmovl P3, P0
cmovl P0, P1
cmovl P1, P3
cmp S1, P0
cmovge P2, P0
cmovg P0, S1
cmp S0, P1
