# n=5 model=out iset=I1 prefix14_class=9483
mov S2, P2
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
cmovl P3, P1
cmp P2, P0
cmovg P2, P0
cmovge P0, S2
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
cmp S1, P0
cmovg P1, P0
