# n=5 model=out iset=I1 prefix14_class=1774
cmp P3, P0
mov S2, P0
cmovge P0, P3
cmovg P3, S2
mov S0, P0
mov S1, P1
cmp P1, P2
cmovl S1, P2
cmovg P1, P2
cmp S0, S1
cmovg P0, S1
cmovle S0, S1
cmp P1, P3
cmovle S0, P1
