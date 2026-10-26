# n=5 model=out iset=I1 prefix14_class=11626
cmp P0, P1
cmovg S2, P0
cmovle S2, P1
cmovg P0, P1
cmp P2, P3
cmovg S0, P2
cmovge P2, P3
mov S1, S2
cmovg P3, S0
cmp S1, P3
cmovg S1, P3
cmovl S2, P3
mov S2, P2
cmp P2, P0
