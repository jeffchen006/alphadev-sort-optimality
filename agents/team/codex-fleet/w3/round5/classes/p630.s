# n=5 model=out iset=I1 prefix14_class=630
mov S2, P1
cmp P3, P0
mov S0, P3
cmovge P3, P0
cmovle S0, P0
cmp S2, P2
cmovg P1, P2
cmovg P2, S2
cmp P2, S0
mov S1, P3
cmovl S2, S0
cmovle S0, P2
cmovge S2, P2
cmp P1, S1
