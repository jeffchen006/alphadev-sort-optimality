# n=5 model=out iset=I1 prefix14_class=6526
mov S1, P1
cmp P1, P3
cmovge P1, P3
mov S2, P1
cmovge P3, S1
mov S1, P0
cmp P2, P0
cmovle P0, P2
cmovl P2, S1
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P0, S2
