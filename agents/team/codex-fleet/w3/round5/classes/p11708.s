# n=5 model=out iset=I1 prefix14_class=11708
mov S0, P1
cmp S0, P2
cmovl S0, P2
cmovge P1, P2
cmovge P2, S0
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
cmp P3, P2
cmovge S0, P3
cmovle P2, P3
cmp P0, P1
cmovle P3, P1
