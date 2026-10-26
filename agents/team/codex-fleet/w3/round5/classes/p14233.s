# n=5 model=out iset=I1 prefix14_class=14233
mov S2, P2
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
mov S1, P1
cmp S2, P0
cmovle S2, P0
cmovl P0, P2
cmp P1, S2
cmovg P1, S2
cmovge S2, S1
cmp P0, P3
cmovle S1, P0
