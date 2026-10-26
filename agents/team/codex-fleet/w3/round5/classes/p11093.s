# n=5 model=out iset=I1 prefix14_class=11093
mov S0, P2
cmp P1, P2
cmovle S0, P1
cmovge P2, P1
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P0, S0
cmovg P1, P0
