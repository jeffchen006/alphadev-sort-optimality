# n=5 model=out iset=I1 prefix14_class=10597
cmp P1, P3
mov S2, P2
cmovge S0, P1
cmovg P1, P3
cmovge P3, S0
cmp P0, S2
cmovg P2, P0
cmovle S2, P0
cmp P2, P3
cmovle P0, P2
cmovl P2, P3
cmovl P3, P0
cmp S2, P1
cmovge S1, P1
