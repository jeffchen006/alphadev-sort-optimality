# n=5 model=out iset=I1 prefix14_class=13085
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovge P3, P0
cmovle P0, P3
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmovl P1, S0
cmp P1, P3
cmovle P0, P1
cmovg P3, P1
cmp P2, S2
cmovl S0, P2
