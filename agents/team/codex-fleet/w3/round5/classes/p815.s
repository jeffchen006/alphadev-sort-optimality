# n=5 model=out iset=I1 prefix14_class=815
mov S2, P0
cmp S2, P1
cmovle S2, P1
cmovge P0, P1
mov P1, P2
cmp P3, P2
mov S0, S2
cmovg P1, P3
cmovle P2, P3
cmp P1, S2
cmovl S2, P1
cmovge S0, P1
mov P1, P2
cmp P0, P2
