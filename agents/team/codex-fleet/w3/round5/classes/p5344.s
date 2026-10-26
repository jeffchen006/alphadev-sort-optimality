# n=5 model=out iset=I1 prefix14_class=5344
cmp P2, P1
mov S2, P1
cmovl S2, P2
cmovge P1, P2
cmp P0, P3
mov S1, P3
cmovg P3, P0
cmovl S1, P0
cmp S1, S2
cmovle S0, S1
cmovl S1, S2
cmovl S2, S0
cmp P1, P3
cmovle S0, P1
