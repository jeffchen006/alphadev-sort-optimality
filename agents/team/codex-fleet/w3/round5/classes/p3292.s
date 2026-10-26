# n=5 model=out iset=I1 prefix14_class=3292
cmp P1, P2
cmovle S1, P2
cmovge S1, P1
cmovg P1, P2
cmovl P2, P1
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovge P3, S0
mov S2, S1
cmp P2, P3
cmovge P1, P3
cmovg P3, P2
cmovle P2, P3
