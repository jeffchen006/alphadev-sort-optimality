# n=5 model=out iset=I1 prefix14_class=5970
mov S1, P3
cmp P0, P3
cmovg P3, P0
cmovl S1, P0
mov S0, P1
cmp P1, P2
cmovle S0, P2
mov S2, P3
cmovge P1, P2
cmp S0, S2
cmovl S2, S0
cmovle S0, P3
cmp P1, S1
cmovge P0, S1
