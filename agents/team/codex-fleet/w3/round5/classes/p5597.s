# n=5 model=out iset=I1 prefix14_class=5597
mov S1, P3
cmp S1, P0
cmovle S1, P0
cmovge P3, P0
mov P0, P3
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmovl P1, S0
cmp P0, P1
cmovge P3, P1
cmovge P1, P0
cmp S1, P2
cmovle S2, S1
