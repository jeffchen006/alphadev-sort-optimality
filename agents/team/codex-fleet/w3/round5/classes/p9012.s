# n=5 model=out iset=I1 prefix14_class=9012
mov S1, P3
cmp P1, P2
cmovge S0, P1
cmovl S0, P2
cmovg P1, P2
cmp P0, S1
cmovl P3, P0
cmovl P0, S1
cmp S0, P0
cmovge P2, P0
cmovg P0, S0
cmovg S0, P2
cmp P1, P3
cmovle S2, P3
