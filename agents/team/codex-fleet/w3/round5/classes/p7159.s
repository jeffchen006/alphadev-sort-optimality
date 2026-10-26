# n=5 model=out iset=I1 prefix14_class=7159
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmovle S0, P1
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
mov P1, P0
cmovl P2, S2
cmp P1, P3
cmovle P0, P3
cmovge P1, P3
cmovge P3, P0
cmp S0, P2
