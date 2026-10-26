# n=5 model=out iset=I1 prefix14_class=2309
cmp P1, P2
cmovle S2, P1
cmovl P1, P2
mov S0, P0
cmovge S2, P2
cmp S0, P3
cmovl S0, P3
cmovge P0, P3
cmp S0, P1
cmovle P3, P1
cmovge P3, S0
cmovl P1, S0
cmp S2, P0
cmovge P2, P0
