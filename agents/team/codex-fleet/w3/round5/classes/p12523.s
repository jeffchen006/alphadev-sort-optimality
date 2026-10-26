# n=5 model=out iset=I1 prefix14_class=12523
mov S2, P2
cmp P3, S2
cmovle S2, P3
mov S0, P1
cmovl P3, P2
cmp P1, P0
cmovg P1, P0
cmovg P0, S0
cmp P1, S2
cmovge S1, S2
cmovg S2, P1
cmovge P1, S1
cmp P0, P3
cmovl P2, P0
