# n=5 model=out iset=I1 prefix14_class=4839
mov S2, P2
cmp P3, P2
cmovl P2, P3
cmovg S2, P3
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
cmovge P0, S0
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
cmovg S0, P2
cmp P0, S2
cmovge S1, P0
