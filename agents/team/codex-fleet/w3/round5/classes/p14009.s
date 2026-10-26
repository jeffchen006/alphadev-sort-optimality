# n=5 model=out iset=I1 prefix14_class=14009
mov S1, P1
cmp P1, P2
cmovge P1, P2
cmovg P2, S1
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
mov S0, P0
cmovl P3, S1
mov S2, P3
cmp P2, P0
cmovl P0, P2
cmovge S0, P2
cmp P1, P3
