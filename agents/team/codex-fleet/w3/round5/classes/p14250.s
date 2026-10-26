# n=5 model=out iset=I1 prefix14_class=14250
cmp P3, P2
mov S1, P0
mov S2, P3
cmovl S2, P2
cmovge P3, P2
cmp P1, S1
cmovge P0, P1
cmovg P1, S1
cmp S2, P0
cmovle S1, P0
cmovl P0, S2
cmovl S2, S1
cmp P3, P1
mov S2, P1
