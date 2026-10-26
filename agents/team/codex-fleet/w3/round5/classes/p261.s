# n=5 model=out iset=I1 prefix14_class=261
cmp P0, P2
mov S2, P0
mov S0, P3
cmovge P0, P2
cmovg P2, S2
cmovg S2, P0
cmp P1, P3
cmovg P3, P1
cmovl S0, P1
cmovl P1, P3
cmp S0, P0
cmovle S2, S0
cmovle S0, P0
cmp P2, P3
