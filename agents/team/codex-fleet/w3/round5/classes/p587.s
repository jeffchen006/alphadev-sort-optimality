# n=5 model=out iset=I1 prefix14_class=587
cmp P0, P3
mov S1, P3
cmovge P3, P0
cmovle S1, P0
mov P0, P3
mov S0, P2
cmp P2, P1
cmovge S0, P1
mov S2, S0
cmovge P1, P2
cmp P1, P0
cmovg P0, P1
cmovl P3, P1
mov P1, P3
