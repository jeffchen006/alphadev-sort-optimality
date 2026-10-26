# n=5 model=out iset=I1 prefix14_class=5513
cmp P3, P0
mov S1, P3
cmovge P3, P0
mov S2, P2
cmovl S1, P0
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
cmp P3, P1
cmovl P2, P1
cmovge P2, P3
cmovg P3, P1
cmp S1, S2
cmovge P1, S1
