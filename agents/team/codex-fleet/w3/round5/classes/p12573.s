# n=5 model=out iset=I1 prefix14_class=12573
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovg P1, P0
cmp P2, P3
cmovle S2, P2
cmovg S2, P3
cmovle P2, P3
cmp S2, P1
mov S0, P1
cmovl S0, S2
cmovl S2, P1
cmp P2, S1
cmovge P1, P2
