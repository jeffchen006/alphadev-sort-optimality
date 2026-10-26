# n=5 model=out iset=I1 prefix14_class=4767
cmp P1, P3
mov S0, P1
cmovl P1, P3
mov S1, P2
cmovle P3, S0
cmp S1, P0
cmovl P2, P0
cmovg S1, P0
cmp S1, P3
cmovge S2, P3
cmovg P3, S1
cmovge S1, S2
cmp P1, P2
cmovl P0, P1
