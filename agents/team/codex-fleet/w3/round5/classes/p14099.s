# n=5 model=out iset=I1 prefix14_class=14099
mov S0, P1
mov S1, P2
cmp P3, S1
cmovge S1, P3
cmovg P3, P2
cmp S0, P0
mov S2, P3
cmovge P1, P0
cmovl S0, P0
cmp S0, S1
cmovle P0, S1
cmovle S1, S0
cmovle S0, P0
cmp P1, S2
