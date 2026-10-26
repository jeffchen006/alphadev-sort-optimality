# n=5 model=out iset=I1 prefix14_class=5697
mov S0, P1
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmovg P3, S2
cmp S0, P2
cmovge S0, P2
mov S2, P0
cmovge P2, P1
cmp S0, P0
cmovle P0, S0
cmovl S0, S2
cmp P2, P3
cmovle S2, P2
