# n=5 model=out iset=I1 prefix14_class=11982
mov S0, P1
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
cmovge S1, P3
cmp S0, P2
cmovle P1, P2
cmovl P2, S0
cmp P2, S1
cmovle P3, S1
cmovl S1, P2
cmovle P2, P3
cmp P0, P1
cmovle P3, P0
