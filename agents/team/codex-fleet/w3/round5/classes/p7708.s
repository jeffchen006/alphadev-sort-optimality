# n=5 model=out iset=I1 prefix14_class=7708
cmp P1, P3
cmovle S0, P1
mov S2, P0
cmovge S0, P3
cmovle P1, P3
cmp P2, S2
cmovge S2, P2
cmovge P2, P0
cmp S0, P2
cmovl P0, P2
cmovle P2, S0
cmovl S0, P0
cmp S2, P1
cmovle P2, P1
