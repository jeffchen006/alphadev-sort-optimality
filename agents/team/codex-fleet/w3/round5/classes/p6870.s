# n=5 model=out iset=I1 prefix14_class=6870
mov S1, P2
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmp P0, P3
mov S2, P1
cmovle S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P0, P1
cmovge S2, P0
cmovle P1, P0
cmp S1, P3
cmovge S2, S1
