# n=5 model=out iset=I1 prefix14_class=12012
cmp P3, P0
mov S2, P2
cmovge S1, P3
cmovge P3, P0
cmovge P0, S1
cmp P2, P1
cmovg S2, P1
cmovl P2, P1
cmp S2, P3
cmovl S0, S2
cmovle S2, P3
cmovl P3, S0
mov P3, P0
cmp P2, P0
