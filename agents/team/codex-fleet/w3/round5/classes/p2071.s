# n=5 model=out iset=I1 prefix14_class=2071
cmp P0, P3
mov S2, P0
cmovle S2, P3
mov S1, P1
cmovl P3, P0
cmp P1, P2
cmovge P1, P2
cmovl S1, P2
cmovg P2, S1
cmp S1, S2
cmovg P2, S2
cmovl S1, S2
cmp P1, P3
cmovl S1, P3
