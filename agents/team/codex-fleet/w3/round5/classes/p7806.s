# n=5 model=out iset=I1 prefix14_class=7806
mov S0, P2
cmp S0, P3
cmovg P2, P3
cmovle S0, P3
cmp P0, P1
mov S2, P2
cmovge P3, P0
cmovg P0, P1
cmovg P1, P3
cmp P0, P2
cmovl S2, P0
cmovge P2, P0
cmp S0, P1
cmovle P3, S0
