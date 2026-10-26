# n=5 model=out iset=I1 prefix14_class=1223
cmp P1, P3
mov S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmovl S0, P2
cmp P1, S0
cmovge S2, P1
cmovg P1, S0
cmovge S0, S2
cmp P0, P3
mov S2, P0
