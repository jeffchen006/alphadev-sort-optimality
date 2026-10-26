# n=5 model=out iset=I1 prefix14_class=8028
mov S1, P2
cmp P2, P3
cmovge S1, P3
mov S0, S1
cmovle P2, P3
mov S2, P0
cmp P0, P1
cmovge S2, P1
cmovl P0, P1
cmp S2, S1
cmovle S1, S2
cmovle S2, S0
cmp P2, P0
cmovle S0, P2
