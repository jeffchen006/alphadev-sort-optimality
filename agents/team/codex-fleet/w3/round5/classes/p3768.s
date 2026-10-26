# n=5 model=out iset=I1 prefix14_class=3768
mov S0, P1
cmp P0, S0
mov S2, P3
cmovle S0, P0
mov S1, S0
cmovg P1, P0
cmp P2, S2
cmovge S2, P2
cmovge P2, P3
cmp S0, P2
cmovl S0, P2
cmovle P2, S1
cmp S2, P1
mov P2, P1
