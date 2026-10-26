# n=5 model=out iset=I1 prefix14_class=2391
cmp P3, P0
cmovge S2, P3
cmovge P3, P0
cmovg P0, S2
mov S1, P2
cmp P2, P1
cmovle S1, P1
mov S0, P0
cmovl P1, P2
cmp S0, S1
cmovl P0, S1
cmovle S1, S0
cmp P3, P1
mov P0, P3
