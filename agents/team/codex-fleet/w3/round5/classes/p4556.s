# n=5 model=out iset=I1 prefix14_class=4556
mov S0, P2
cmp P2, P1
mov S2, P0
cmovg P2, P1
cmovle S0, P1
cmovge P1, S0
cmp P0, P3
cmovge P0, P3
cmovl S2, P3
cmp S2, P1
cmovg P1, S2
cmovl S0, S2
cmp P2, P0
cmovge S2, P2
