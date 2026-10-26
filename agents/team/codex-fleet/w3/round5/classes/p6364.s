# n=5 model=out iset=I1 prefix14_class=6364
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
mov S0, P2
cmovg P0, S1
cmp P3, P2
cmovl P2, P3
cmovge S0, P3
cmp S0, P0
cmovge S2, P0
cmovle S2, S0
cmovge P0, S0
cmp P1, P2
mov P3, P2
