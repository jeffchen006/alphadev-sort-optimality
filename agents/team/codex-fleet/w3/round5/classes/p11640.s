# n=5 model=out iset=I1 prefix14_class=11640
cmp P2, P1
mov S2, P2
cmovg P2, P1
cmovl S2, P1
mov S0, S2
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovge P3, S1
cmp S0, P3
cmovle S2, P3
cmovg S0, P3
cmp P2, P0
cmovl P3, S0
