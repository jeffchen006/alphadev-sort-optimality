# n=5 model=out iset=I1 prefix14_class=13624
cmp P1, P0
cmovle S2, P1
cmovle P1, P0
cmovle P0, S2
mov S0, P3
cmp P2, S0
cmovg S0, P2
cmovge P2, P3
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovl S1, P2
cmp S0, P1
cmovge S2, P1
