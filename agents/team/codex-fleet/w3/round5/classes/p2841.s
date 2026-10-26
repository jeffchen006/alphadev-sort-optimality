# n=5 model=out iset=I1 prefix14_class=2841
cmp P3, P0
cmovg S1, P3
cmovle S1, P0
mov S2, P1
cmovg P3, P0
cmp P1, P2
cmovg P1, P2
cmovg P2, S2
cmovl S2, P2
cmp S2, S1
cmovge S2, S1
cmovg S1, P2
cmp P3, P1
mov S1, P1
