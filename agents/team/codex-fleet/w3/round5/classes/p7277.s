# n=5 model=out iset=I1 prefix14_class=7277
cmp P2, P3
mov S0, P3
mov S1, P1
cmovge S0, P2
cmovle P3, P2
cmp P0, S1
cmovl P1, P0
cmovle P0, S1
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp P0, S0
cmovg P1, S0
