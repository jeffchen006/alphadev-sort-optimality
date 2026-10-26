# n=5 model=out iset=I1 prefix14_class=95
cmp P0, P3
cmovle S1, P3
mov S2, P2
cmovg S1, P0
cmovge P0, P3
cmp P1, P2
cmovge S2, P1
cmovl P2, P1
mov P3, S2
cmp P0, P2
mov S0, P2
cmovl P2, P0
cmovge S0, P0
cmp S2, S1
