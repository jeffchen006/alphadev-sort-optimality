# n=5 model=out iset=I1 prefix14_class=906
mov S0, P2
mov S1, P3
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmovle P3, S1
cmp S0, P0
cmovge S0, P0
cmovg P0, P2
cmp P0, P3
cmovg S1, P0
cmovle P3, P0
mov S2, S0
cmovge P0, P3
