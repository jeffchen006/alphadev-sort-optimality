# n=5 model=out iset=I1 prefix14_class=2326
mov S0, P1
mov S1, P3
cmp P1, P0
cmovle P1, P0
cmovge S0, P0
cmp S1, P2
cmovl P3, P2
cmovge S1, P2
cmp P1, P3
cmovg S2, P1
cmovle S2, P3
cmovle P3, P1
cmp S1, S0
cmovl P2, S0
