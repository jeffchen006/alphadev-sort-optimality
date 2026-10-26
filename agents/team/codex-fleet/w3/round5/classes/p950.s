# n=5 model=out iset=I1 prefix14_class=950
cmp P2, P0
cmovl S0, P0
mov S1, P3
cmovge S0, P2
cmovl P0, P2
cmp P3, P1
mov S2, S0
cmovg P3, P1
cmovg P1, S1
cmp P1, S2
cmovg S0, P1
cmovge P1, S2
cmp P3, P0
cmovle S2, P3
