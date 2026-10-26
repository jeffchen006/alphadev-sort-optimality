# n=5 model=out iset=I1 prefix14_class=2600
cmp P3, P2
cmovg S0, P2
cmovge P2, P3
cmovg P3, S0
mov S1, P1
cmp P1, P0
cmovl S1, P0
cmovg P1, P0
cmp S1, P2
mov S2, S1
cmovg S2, P2
cmovle S1, P2
cmp P1, P3
cmovge S1, P3
