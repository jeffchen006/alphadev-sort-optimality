# n=5 model=out iset=I1 prefix14_class=14470
cmp P3, P0
cmovge S0, P3
cmovge P3, P0
cmovge P0, S0
mov S1, P1
mov S2, P3
cmp P1, P2
cmovle S1, P2
cmovg P1, P2
cmp P1, P3
cmovge S2, P1
cmovl P3, P1
cmp P0, S1
mov P3, P0
