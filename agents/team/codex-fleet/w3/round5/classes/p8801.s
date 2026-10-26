# n=5 model=out iset=I1 prefix14_class=8801
mov S2, P1
cmp P0, P1
cmovle P1, P0
cmovge S2, P0
mov S0, P3
cmp P2, P3
cmovge S0, P2
mov S1, S0
cmovl P3, P2
cmp S1, S2
cmovge S1, S2
cmovle S0, S2
cmp P3, P1
cmovle S0, P3
