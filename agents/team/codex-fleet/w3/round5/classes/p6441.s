# n=5 model=out iset=I1 prefix14_class=6441
cmp P1, P3
mov S0, P3
cmovg P3, P1
cmovle S0, P1
mov S1, P2
cmp P0, S1
cmovg P2, P0
mov P1, P3
cmovl S1, P0
cmp P2, P3
cmovge P3, P2
cmovle P1, P2
cmp S0, S1
cmovge P2, S0
