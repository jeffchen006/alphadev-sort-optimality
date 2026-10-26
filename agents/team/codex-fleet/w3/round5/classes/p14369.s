# n=5 model=out iset=I1 prefix14_class=14369
mov S1, P0
cmp P2, S1
cmovl P0, P2
cmovg S1, P2
cmovge P2, P0
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmovg P3, S2
cmp P0, P1
cmovle P2, P1
cmovge P0, P1
cmp P3, S1
cmovge S0, P3
