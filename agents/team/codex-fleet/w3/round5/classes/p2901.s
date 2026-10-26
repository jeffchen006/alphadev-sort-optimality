# n=5 model=out iset=I1 prefix14_class=2901
mov S1, P1
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
cmovle P2, S0
mov S2, P2
cmp P1, P3
cmovge P1, P3
cmovl S1, P3
cmp S2, S1
cmovl S2, S1
cmovle S1, P2
mov S2, P1
cmp S2, P0
