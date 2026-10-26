# n=5 model=out iset=I1 prefix14_class=4059
mov S2, P0
mov S1, P1
cmp S1, P2
cmovg P1, P2
cmovg P2, S1
cmp P3, S2
cmovl P0, P3
cmovg S2, P3
cmp P1, P0
cmovle S1, P0
cmovge S1, P1
cmovl P0, P1
cmp P2, S2
cmovle S0, P2
