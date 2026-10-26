# n=5 model=out iset=I1 prefix14_class=5592
mov S0, P3
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovg P2, S1
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
cmp P0, P1
cmovge S1, P1
cmovle S1, P0
mov S1, S0
cmovge P1, P0
mov P0, P1
