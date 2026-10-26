# n=5 model=out iset=I1 prefix14_class=9249
cmp P3, P2
cmovl S1, P3
cmovge S1, P2
cmovg P2, P3
mov S2, S1
cmp P1, P0
cmovge P3, P1
cmovg P1, P0
cmovg P0, P3
cmp S1, P1
cmovg S1, P1
cmovle S2, P1
cmp P2, P0
cmovle S0, P2
