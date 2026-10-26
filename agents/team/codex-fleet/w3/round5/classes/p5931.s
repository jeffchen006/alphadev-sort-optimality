# n=5 model=out iset=I1 prefix14_class=5931
mov S2, P0
cmp S2, P3
cmovg S2, P3
cmovl P0, P3
cmp P2, P1
mov S0, P1
cmovle P1, P2
cmovle P2, S0
cmovge S0, P2
cmp P2, P0
cmovle P2, P0
cmovg S0, P0
cmp S2, P1
cmovge S1, S2
