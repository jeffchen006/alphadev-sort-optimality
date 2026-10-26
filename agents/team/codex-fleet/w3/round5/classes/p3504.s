# n=5 model=out iset=I1 prefix14_class=3504
mov S0, P0
cmp P3, P2
cmovle S1, P2
cmovge S1, P3
cmovg P3, P2
cmp P0, P1
mov P2, P3
cmovl P0, P1
cmovge S0, P1
cmp S0, P2
cmovge P2, S0
cmovge S0, P3
cmp S1, P0
cmovle S2, P0
