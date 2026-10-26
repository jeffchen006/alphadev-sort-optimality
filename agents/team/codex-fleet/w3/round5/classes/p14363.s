# n=5 model=out iset=I1 prefix14_class=14363
cmp P2, P0
cmovle S0, P0
cmovg S0, P2
cmovge P2, P0
cmp P3, P1
cmovg P0, P3
cmovg P3, P1
mov S2, P2
cmovg P1, P0
cmp S2, P3
cmovl P2, P3
cmovl P3, S2
cmp P1, S0
cmovge P0, S0
