# n=5 model=out iset=I1 prefix14_class=1666
mov S1, P1
cmp P0, P3
mov S0, P3
cmovge P3, P0
cmovl S0, P0
cmp S1, P2
cmovg P1, P2
cmovg P2, S1
cmp P1, S0
cmovle P0, S0
mov S2, P3
cmovge P0, P1
cmovle S0, P1
mov S0, P0
