# n=5 model=out iset=I1 prefix14_class=9805
mov S1, P3
cmp S1, P1
cmovge S1, P1
cmovl P3, P1
cmp P0, P2
cmovle S2, P2
cmovg S2, P0
mov S0, S2
cmovge P0, P2
cmp P3, S0
cmovg S2, P3
cmovl S0, P3
mov S2, S0
mov P3, P0
