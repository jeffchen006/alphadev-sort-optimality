# n=5 model=out iset=I1 prefix14_class=3746
cmp P0, P3
mov S0, P3
mov S2, P2
cmovge S0, P0
cmovl P3, P0
cmovg P0, P3
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmp P1, P3
cmovg P3, P1
cmovl P0, P1
cmp S2, S0
cmovle P2, S2
