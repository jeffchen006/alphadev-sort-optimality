# n=5 model=out iset=I1 prefix14_class=12027
cmp P3, P1
cmovge S2, P3
cmovg P3, P1
cmovge P1, S2
mov S1, P0
cmp P2, P0
cmovle P0, P2
cmovl P2, S1
cmp P3, P0
cmovg S1, P0
cmovle S1, P3
cmovg P0, P3
mov S0, P1
mov S1, P0
