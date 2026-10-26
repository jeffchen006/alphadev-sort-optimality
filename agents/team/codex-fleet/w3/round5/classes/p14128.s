# n=5 model=out iset=I1 prefix14_class=14128
mov S1, P0
cmp P0, P3
cmovl S1, P3
cmovg P0, P3
mov S2, P1
cmp P2, P1
cmovge P1, P2
cmovle S2, P2
cmp S1, P1
cmovle P3, S1
cmovl S1, P1
cmovl P1, P3
cmp P0, S2
cmovge P2, S2
