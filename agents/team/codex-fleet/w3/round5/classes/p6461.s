# n=5 model=out iset=I1 prefix14_class=6461
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovle P3, P2
mov S1, S2
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
cmovg P0, P2
cmp P1, S1
