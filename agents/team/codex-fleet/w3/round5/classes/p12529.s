# n=5 model=out iset=I1 prefix14_class=12529
cmp P3, P2
mov S0, P0
cmovle S2, P3
cmovl P3, P2
cmovle P2, S2
mov S1, P2
cmp P0, P1
cmovge P0, P1
cmovge P1, S0
cmp P0, S1
cmovge S1, P0
cmovg P0, P2
cmp P3, P1
cmovle P0, P3
