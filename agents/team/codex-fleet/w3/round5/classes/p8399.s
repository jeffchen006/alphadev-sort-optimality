# n=5 model=out iset=I1 prefix14_class=8399
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovg S1, P3
cmp P2, P1
cmovle S0, P1
cmovg S0, P2
mov S2, S1
cmovge P2, P1
cmp S2, S0
cmovl S2, S0
cmovg S1, S0
cmp P2, P0
cmovge S2, P2
