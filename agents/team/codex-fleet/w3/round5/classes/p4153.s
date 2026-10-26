# n=5 model=out iset=I1 prefix14_class=4153
mov S0, P0
cmp P3, P1
cmovge S2, P1
cmovl S2, P3
cmovg P1, P3
cmp P2, S0
mov S1, S2
cmovl S0, P2
cmovge P0, P2
cmp S0, S1
cmovg S2, S0
cmovle S1, S0
cmp P0, P1
cmovg P2, P0
