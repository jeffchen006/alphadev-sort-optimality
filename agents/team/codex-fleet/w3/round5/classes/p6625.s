# n=5 model=out iset=I1 prefix14_class=6625
mov S2, P0
mov S1, P3
cmp P2, P0
cmovg P0, P2
cmovle S2, P2
cmp P3, P1
cmovl P3, P1
cmovge S1, P1
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
cmovge P3, S0
cmp S2, S1
cmovg P2, S2
