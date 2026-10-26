# n=5 model=out iset=I1 prefix14_class=2380
cmp P0, P1
cmovle S2, P0
mov S1, P3
cmovge S2, P1
cmovg P1, P0
cmp P2, S1
mov S0, P1
cmovle S1, P2
cmovg P3, P2
cmp P1, P3
cmovl P1, P3
cmovl P3, S0
cmp S1, S2
cmovg P1, S1
