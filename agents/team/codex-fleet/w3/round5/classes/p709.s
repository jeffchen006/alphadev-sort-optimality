# n=5 model=out iset=I1 prefix14_class=709
cmp P3, P2
cmovge S0, P2
cmovle S0, P3
mov S2, P0
cmovle P3, P2
cmp P0, P1
mov S1, P3
cmovge S2, P1
cmovle P0, P1
cmp S1, P0
cmovle S1, P0
mov S1, S2
cmovl P0, P3
cmp S2, S0
