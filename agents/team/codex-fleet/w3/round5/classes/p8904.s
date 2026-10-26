# n=5 model=out iset=I1 prefix14_class=8904
mov S2, P2
cmp P0, P3
mov S0, P0
cmovle P0, P3
cmovg S0, P3
cmp P1, S2
cmovl S2, P1
cmovle P1, P2
cmp P0, P1
cmovle S1, P1
cmovge S1, P0
cmovl P1, P0
cmp S0, S2
cmovle P3, S2
