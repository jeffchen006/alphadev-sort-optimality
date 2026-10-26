# n=5 model=out iset=I1 prefix14_class=5855
mov S1, P1
mov S2, P2
cmp P0, S2
cmovge S2, P0
cmovge P0, P2
cmp S1, P3
cmovle S1, P3
cmovge P1, P3
cmp P1, P0
cmovl P3, P1
cmovle P1, P0
mov S0, S1
cmovl P0, P3
cmp S1, S2
