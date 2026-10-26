# n=5 model=out iset=I1 prefix14_class=14279
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
cmovle P1, S1
mov S0, P3
cmp P2, S0
cmovge S0, P2
cmovl P3, P2
cmovle P2, S0
cmp S0, P1
cmovl P2, P1
cmovle P1, S0
cmp P0, P3
cmovge S1, P3
