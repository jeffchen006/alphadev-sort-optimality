# n=5 model=out iset=I1 prefix14_class=8646
cmp P1, P3
cmovl S2, P1
mov S1, P2
cmovge S2, P3
cmovle P1, P3
cmp P0, S1
cmovle P2, P0
mov S0, P1
cmovg S1, P0
cmp S1, P1
cmovg S0, S1
cmovle P1, S1
cmp P2, S2
cmovl P0, S2
