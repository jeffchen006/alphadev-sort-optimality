# n=5 model=out iset=I1 prefix14_class=1814
cmp P0, P3
cmovge S0, P3
mov S2, P2
cmovge P3, P0
cmovg P0, S0
cmp P1, S2
cmovg S2, P1
cmovge P1, P2
cmovge P2, S2
cmp P3, S2
cmovle P2, P3
cmovl P3, S2
cmp P0, P1
cmovge S0, P1
