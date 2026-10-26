# n=5 model=out iset=I1 prefix14_class=4550
mov S2, P3
mov S1, P0
cmp P0, P2
cmovle S1, P2
cmovg P0, P2
cmp S2, P1
mov S0, S1
cmovl S2, P1
cmovge P3, P1
cmp S2, S0
cmovge S0, S2
cmovge P2, P3
cmovle S1, S2
cmp P0, P3
