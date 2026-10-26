# n=5 model=out iset=I1 prefix14_class=2124
cmp P3, P0
mov S2, P2
mov S0, P0
cmovle S0, P3
cmovg P0, P3
cmp S2, P1
cmovle S2, P1
cmovge P2, P1
mov S1, P0
cmp P0, S2
cmovl P0, S2
cmovle S2, S1
cmovge S1, S2
mov P0, S0
