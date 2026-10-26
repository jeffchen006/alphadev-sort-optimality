# n=5 model=out iset=I1 prefix14_class=3755
cmp P3, P2
mov S1, P0
cmovge S2, P2
cmovge P2, P3
cmovle S2, P3
cmp P1, P0
cmovge P0, P1
cmovg P1, S1
cmp S2, P1
mov S0, S2
cmovl S0, P1
cmovle P1, S2
cmp P0, P2
cmovg S2, P2
