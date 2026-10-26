# n=5 model=out iset=I1 prefix14_class=10366
cmp P2, P0
mov S1, P1
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P3, P1
cmovg P1, P3
cmovl S1, P3
cmp P1, P0
cmovg S2, P0
cmovge P0, P1
cmovle S2, P1
cmp P2, S1
cmovle P1, S1
