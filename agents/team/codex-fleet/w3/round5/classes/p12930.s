# n=5 model=out iset=I1 prefix14_class=12930
cmp P2, P1
mov S1, P3
cmovg S0, P1
cmovg P1, P2
cmovg P2, S0
cmp P0, S1
cmovge S1, P0
cmovl P3, P0
mov S2, P2
cmp P3, P2
cmovg S2, P3
cmovle P2, P3
cmp P1, S1
cmovg S0, S1
