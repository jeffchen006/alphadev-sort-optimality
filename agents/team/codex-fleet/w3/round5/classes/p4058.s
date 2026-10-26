# n=5 model=out iset=I1 prefix14_class=4058
mov S2, P0
mov S1, P1
cmp S1, P2
cmovg P1, P2
cmovg P2, S1
cmp P3, P0
cmovl S2, P3
cmovg P0, P3
cmp P1, S2
cmovle S1, S2
cmovge S1, P1
cmovle S2, P1
cmp P2, P0
cmovle S2, P2
