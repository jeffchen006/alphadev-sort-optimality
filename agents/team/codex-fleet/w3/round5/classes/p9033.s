# n=5 model=out iset=I1 prefix14_class=9033
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
cmovle P2, S1
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovge P1, S0
cmp P2, P0
cmovge S1, P2
cmovl S1, P0
cmovl P0, P2
mov S1, P3
cmp P1, P3
