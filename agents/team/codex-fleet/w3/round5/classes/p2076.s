# n=5 model=out iset=I1 prefix14_class=2076
cmp P1, P3
cmovle S0, P1
cmovge S0, P3
cmovg P3, P1
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovge P0, P2
mov S1, S0
cmovge P2, S2
cmp S2, P3
cmovg P2, P3
cmovl S2, P3
mov S2, P2
