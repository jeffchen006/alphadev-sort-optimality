# n=5 model=out iset=I1 prefix14_class=3511
mov S2, P3
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovg P1, S0
cmp P2, P3
cmovl P3, P2
cmovle P2, S2
mov S1, P3
cmp P3, P1
cmovle S1, P1
mov S2, P2
cmovg P3, P1
cmp P0, P2
