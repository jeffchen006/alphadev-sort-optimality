# n=5 model=out iset=I1 prefix14_class=1998
mov S1, P3
mov S0, P0
cmp S1, P1
cmovg P3, P1
cmovle S1, P1
cmp P2, S0
cmovle S0, P2
cmovge P0, P2
cmp S1, P0
cmovl S2, P0
cmovge S2, S1
cmovle P0, S1
cmp S0, P3
mov S2, S0
