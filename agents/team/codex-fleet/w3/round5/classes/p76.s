# n=5 model=out iset=I1 prefix14_class=76
cmp P1, P0
mov S1, P3
cmovge S0, P1
cmovl S0, P0
cmovg P1, P0
cmp P2, P3
cmovg P3, P2
cmovle S1, P2
cmovge P2, S1
cmp S1, P1
cmovge P2, P1
cmovg P1, S1
cmp P3, S0
cmovle P2, P3
