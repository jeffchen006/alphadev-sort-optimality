# n=5 model=out iset=I1 prefix14_class=10704
mov S2, P2
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovle P0, S1
cmp P1, S2
cmovge S2, P1
cmovle P2, P1
mov S0, S2
cmp S0, P3
cmovl S2, P3
cmovle P3, S0
cmp P0, P2
cmovge S1, P2
