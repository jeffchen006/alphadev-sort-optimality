# n=5 model=out iset=I1 prefix14_class=368
cmp P1, P3
cmovle S2, P3
cmovge S2, P1
cmovg P1, P3
cmp P2, P0
mov S0, P1
cmovge S1, P2
cmovg P2, P0
cmovg P0, S1
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmp S2, P0
cmovle S1, P0
