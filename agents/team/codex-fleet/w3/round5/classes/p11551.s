# n=5 model=out iset=I1 prefix14_class=11551
mov S1, P2
mov S0, P1
cmp P0, S1
cmovle P2, P0
cmovge S1, P0
cmp P3, P1
cmovge S0, P3
cmovle P1, P3
mov S2, P1
cmp P1, P2
cmovg S2, P2
cmovl P1, P2
cmp S1, S0
cmovle P3, S1
