# n=5 model=out iset=I1 prefix14_class=13432
cmp P1, P3
mov S0, P0
cmovge S2, P1
cmovge P1, P3
cmovge P3, S2
cmp P2, S0
cmovl S0, P2
cmovge P0, P2
cmovg P2, S0
cmp S0, P1
cmovle S0, P1
cmovle P1, P2
cmp P3, P0
cmovle P2, P0
