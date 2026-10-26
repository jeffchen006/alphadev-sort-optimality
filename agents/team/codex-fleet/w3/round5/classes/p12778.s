# n=5 model=out iset=I1 prefix14_class=12778
mov S2, P1
cmp P2, S2
cmovge P1, P2
cmovge P2, S2
cmp P3, P0
cmovl S2, P0
cmovge S2, P3
cmovle P0, P3
cmovle P3, S2
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P1, P3
