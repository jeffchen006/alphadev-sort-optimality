# n=5 model=out iset=I1 prefix14_class=4987
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P1, P2
cmovge S1, P2
cmovge P2, P1
cmovg P1, S1
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
mov S2, P3
cmovl P0, S0
cmp S2, P2
