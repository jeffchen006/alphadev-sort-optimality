# n=5 model=out iset=I1 prefix14_class=7095
mov S0, P2
cmp P1, S0
cmovge S0, P1
cmovg P1, P2
cmp P3, P0
mov S1, P3
mov S2, P1
cmovg P3, P0
cmovge P0, S1
cmp P3, P1
cmovle P1, P3
cmovge S2, P3
cmp P0, S0
cmovl P3, S0
