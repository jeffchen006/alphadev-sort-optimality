# n=5 model=out iset=I1 prefix14_class=4807
mov S2, P3
cmp P1, P3
cmovg S2, P1
cmovle P3, P1
cmp P2, P0
cmovge P1, P2
cmovge P2, P0
cmovg P0, P1
cmp P3, P2
cmovl S1, P2
cmovge S1, P3
cmovle P2, P3
cmp S2, P0
cmovl P2, P0
