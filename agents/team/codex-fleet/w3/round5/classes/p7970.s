# n=5 model=out iset=I1 prefix14_class=7970
cmp P1, P2
mov S0, P0
cmovge S1, P1
cmovg P1, P2
cmovge P2, S1
cmp P0, P3
mov S2, P1
cmovg S0, P3
cmovl P0, P3
cmp S0, P1
cmovg P1, S0
cmovl S2, S0
cmovle S0, P1
cmp P2, P0
