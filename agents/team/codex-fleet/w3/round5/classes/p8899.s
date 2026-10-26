# n=5 model=out iset=I1 prefix14_class=8899
mov S0, P1
cmp S0, P3
cmovge P1, P3
mov S1, P0
cmovle S0, P3
cmp S1, P2
cmovg P0, P2
cmovle S1, P2
cmp S1, S0
cmovl S2, S1
mov P2, P1
cmovl S1, S0
cmovl S0, S2
cmp P0, P2
