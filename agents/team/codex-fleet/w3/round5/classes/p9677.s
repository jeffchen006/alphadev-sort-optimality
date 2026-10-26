# n=5 model=out iset=I1 prefix14_class=9677
cmp P3, P0
mov S0, P3
cmovle S0, P0
mov S2, P2
cmovg P3, P0
cmp S2, P1
cmovge P2, P1
cmovl S2, P1
cmp S2, S0
mov S1, S2
cmovl S1, S0
cmovge S2, S0
cmp P3, P2
cmovge P0, P3
