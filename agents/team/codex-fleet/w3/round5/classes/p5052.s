# n=5 model=out iset=I1 prefix14_class=5052
mov S0, P0
mov S2, P3
cmp P1, S2
cmovl S2, P1
cmovg P3, P1
mov S1, S2
cmp P2, P0
cmovge P0, P2
cmovle S0, P2
cmp S0, S1
cmovge S1, S0
cmovl S2, S0
cmp P0, P3
cmovg S2, P0
