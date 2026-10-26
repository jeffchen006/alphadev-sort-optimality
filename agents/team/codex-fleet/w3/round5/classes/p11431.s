# n=5 model=out iset=I1 prefix14_class=11431
mov S0, P0
cmp P0, P3
cmovge P0, P3
cmovle S0, P3
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P1, P0
cmovle S2, P0
cmovg S2, P1
cmovl P0, P1
mov P3, S2
cmp S0, P2
