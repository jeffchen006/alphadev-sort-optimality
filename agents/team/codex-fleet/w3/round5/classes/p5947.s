# n=5 model=out iset=I1 prefix14_class=5947
cmp P3, P0
mov S1, P2
mov S0, P0
cmovge P0, P3
cmovl S0, P3
cmp S1, P1
cmovle P2, P1
cmovge S1, P1
mov S2, P0
cmp S2, P2
cmovle S2, P2
cmovge P0, P2
cmp S0, S1
cmovl P2, P0
