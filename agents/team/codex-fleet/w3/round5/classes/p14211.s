# n=5 model=out iset=I1 prefix14_class=14211
mov S1, P1
cmp S1, P3
cmovle S1, P3
cmovge P1, P3
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
mov P3, P0
cmp S1, P2
cmovle S2, P2
cmovl P2, S1
mov S0, P2
cmovle S1, S2
