# n=5 model=out iset=I1 prefix14_class=3860
cmp P2, P0
cmovl S0, P2
cmovge S0, P0
cmovge P0, P2
mov S2, P1
cmp S2, P3
cmovl S2, P3
cmovle P3, P1
mov S1, S0
cmp S1, P3
cmovle S1, P3
cmovle P3, S0
mov S0, P0
cmp S2, S0
