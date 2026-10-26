# n=5 model=out iset=I1 prefix14_class=1395
mov S0, P2
cmp P0, P1
cmovge S1, P1
cmovle S1, P0
cmovg P1, P0
cmp P2, P3
cmovge S0, P3
mov P0, P1
cmovge P3, P2
cmp P3, P0
cmovl P1, P3
cmovl P3, P0
mov P3, S1
cmp P3, S0
