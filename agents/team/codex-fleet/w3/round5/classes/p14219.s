# n=5 model=out iset=I1 prefix14_class=14219
mov S0, P1
cmp P3, S0
mov S2, P0
cmovle S0, P3
cmovl P3, P1
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmp S2, P3
cmovle P0, P3
cmovl P3, S2
cmovl S2, P0
mov S2, S0
cmp S2, P2
