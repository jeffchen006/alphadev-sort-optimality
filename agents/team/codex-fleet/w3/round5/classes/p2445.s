# n=5 model=out iset=I1 prefix14_class=2445
mov S2, P2
cmp S2, P1
cmovg P2, P1
cmovl S2, P1
mov P1, P3
cmp P0, P3
cmovge P3, P0
cmovge P0, P1
cmovge P1, P3
cmp P3, S2
cmovle P3, S2
cmovle S2, P1
cmp P0, P2
cmovle S0, P2
