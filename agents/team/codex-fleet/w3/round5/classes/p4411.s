# n=5 model=out iset=I1 prefix14_class=4411
mov S1, P0
cmp S1, P3
cmovle P0, P3
cmovge S1, P3
cmp P1, P2
mov S2, P1
cmovg S2, P2
cmovg P2, P1
cmp P0, P2
cmovl P3, P0
cmovle P0, P2
cmovl P2, P3
mov S0, S1
cmp S0, S2
