# n=5 model=out iset=I1 prefix14_class=11881
cmp P0, P3
mov S2, P1
cmovge S0, P3
cmovge P3, P0
cmovge P0, S0
cmp S2, P2
cmovle S2, P2
mov S1, P0
cmovge P1, P2
cmp S2, P3
cmovle P2, S2
cmovl S2, P3
cmovl P3, P2
cmp P0, P1
