# n=5 model=out iset=I1 prefix14_class=1806
mov S1, P3
cmp P1, P3
cmovge P3, P1
mov S0, P2
cmovg P1, S1
cmp P0, S0
cmovge S0, P0
cmovge P0, P2
cmp P3, S0
cmovge S1, S0
cmovl S1, P3
cmovle P3, S0
cmp P0, P1
cmovg S2, P1
