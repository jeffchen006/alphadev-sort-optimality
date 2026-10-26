# n=5 model=out iset=I1 prefix14_class=5703
mov S1, P3
mov S2, P0
cmp S2, P2
cmovge P0, P2
cmovge P2, S2
cmp P1, P3
mov S2, P0
cmovg P3, P1
cmovl S1, P1
cmp S1, S2
cmovle S2, S1
cmovl S1, P0
cmp P2, P3
cmovl P0, P2
