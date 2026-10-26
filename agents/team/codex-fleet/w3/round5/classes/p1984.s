# n=5 model=out iset=I1 prefix14_class=1984
mov S2, P3
cmp P2, P0
cmovge S1, P2
cmovle S1, P0
cmovge P2, P0
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
mov P3, P1
cmp P3, S1
cmovle P3, S1
cmovl S1, P1
cmp P2, S2
cmovl S0, P2
