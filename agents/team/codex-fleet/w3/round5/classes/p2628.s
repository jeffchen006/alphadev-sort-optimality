# n=5 model=out iset=I1 prefix14_class=2628
mov S0, P3
cmp P2, P3
cmovge P3, P2
mov S2, P0
cmovg P2, S0
cmp P1, S2
cmovl S2, P1
cmovg P0, P1
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P2, S2
cmovle S1, S2
