# n=5 model=out iset=I1 prefix14_class=9250
cmp P3, P2
cmovl S1, P3
cmovge S1, P2
cmovge P2, P3
mov S2, S1
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
cmovg P0, S0
cmp S1, P1
cmovle S2, P1
cmovg S1, P1
cmp P2, P0
cmovl S0, P2
