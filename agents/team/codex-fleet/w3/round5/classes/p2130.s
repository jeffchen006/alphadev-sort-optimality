# n=5 model=out iset=I1 prefix14_class=2130
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
cmovl S0, P1
mov S1, P0
cmp S1, P3
cmovge P0, P3
cmovle S1, P3
cmovg P3, S1
cmp S1, P2
cmovge P3, P2
cmovl S1, P2
mov S1, P3
cmp P0, S0
