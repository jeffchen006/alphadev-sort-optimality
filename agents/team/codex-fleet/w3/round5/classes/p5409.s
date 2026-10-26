# n=5 model=out iset=I1 prefix14_class=5409
mov S0, P0
cmp P1, P2
cmovl S2, P2
cmovge S2, P1
cmovg P1, P2
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovge P0, P3
cmp P0, P1
cmovge P3, P1
cmovg P1, P0
cmp S0, S2
cmovg P3, S0
