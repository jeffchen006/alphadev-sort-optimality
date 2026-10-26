# n=5 model=out iset=I1 prefix14_class=9210
mov S2, P1
cmp P3, S2
cmovl S2, P3
mov S0, P0
cmovl P3, P1
cmp P2, P0
cmovle S0, P2
cmovg P0, P2
cmp S2, S0
cmovge P1, S2
cmovge S2, S0
cmovg S0, P1
mov S1, P0
cmp P3, S1
