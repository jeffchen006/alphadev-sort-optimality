# n=5 model=out iset=I1 prefix14_class=5967
cmp P1, P0
cmovle S0, P0
mov S2, P2
cmovl P0, P1
cmovg S0, P1
cmp P2, P3
cmovge P2, P3
mov S1, P2
cmovge P3, S2
cmp S0, P3
cmovl S2, P3
cmovl P3, S0
cmovl S0, S2
cmp P0, S1
