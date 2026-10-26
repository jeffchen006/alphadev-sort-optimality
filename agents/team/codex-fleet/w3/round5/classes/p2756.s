# n=5 model=out iset=I1 prefix14_class=2756
cmp P3, P0
mov S1, P3
cmovle S1, P0
cmovge P3, P0
cmp P2, P1
cmovl P0, P2
cmovge P0, P1
cmovle P2, P1
cmp S1, P2
mov S0, P0
cmovl S2, P2
cmovle P2, S1
cmovl S1, S2
cmp P0, P3
