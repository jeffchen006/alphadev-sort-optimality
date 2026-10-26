# n=5 model=out iset=I1 prefix14_class=8561
mov S1, P3
cmp P0, S1
cmovge S1, P0
mov S0, P1
cmovle P3, P0
cmp P1, P2
mov S2, S1
cmovl P1, P2
cmovg S0, P2
cmp S1, P1
cmovge S1, P1
cmovg P1, S2
cmp P3, S0
cmovle P2, P3
