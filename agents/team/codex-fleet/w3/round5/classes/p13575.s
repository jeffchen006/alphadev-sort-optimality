# n=5 model=out iset=I1 prefix14_class=13575
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovge S1, P0
mov P0, P2
cmp P1, P3
cmovge S0, P1
cmovge P1, P3
cmovg P3, S0
cmp P2, P1
cmovge P2, P1
cmovl P0, P1
cmp P3, S1
mov P2, P0
