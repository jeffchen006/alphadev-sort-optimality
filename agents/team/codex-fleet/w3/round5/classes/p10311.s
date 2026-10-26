# n=5 model=out iset=I1 prefix14_class=10311
mov S0, P0
mov S1, P3
cmp P1, P0
cmovle S0, P1
cmovle P1, P0
cmp P2, S1
cmovge S1, P2
cmovle P3, P2
mov S2, P1
cmp S2, S1
cmovl S2, S1
cmovle S1, P1
cmp S0, P3
cmovge P1, P3
