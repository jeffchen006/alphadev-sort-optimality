# n=5 model=out iset=I1 prefix14_class=2783
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
cmovge P2, P1
cmovg P1, S1
cmp P3, P0
mov S0, P3
cmovg P3, P0
cmovl S0, P0
cmp S1, S0
cmovge P1, S0
cmovg S0, S1
cmp P2, P3
cmovle S2, P2
