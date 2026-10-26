# n=5 model=out iset=I1 prefix14_class=5638
cmp P1, P2
mov S1, P0
cmovg S2, P1
cmovg P1, P2
cmovle S2, P2
cmp P3, S1
cmovl S1, P3
cmovge P0, P3
cmp S1, P1
cmovge P2, P1
mov S0, S2
cmovg P1, S1
cmovg S1, P2
cmp S2, P0
