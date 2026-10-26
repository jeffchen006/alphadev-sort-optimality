# n=5 model=out iset=I1 prefix14_class=1846
cmp P2, P1
cmovge S1, P2
cmovle S1, P1
mov S0, P3
cmovl P1, P2
cmp P0, P3
cmovg P3, P0
mov P2, S1
cmovge P0, S0
cmp P2, P3
cmovle P2, P3
cmovge S1, P3
mov P2, P1
mov P3, S1
