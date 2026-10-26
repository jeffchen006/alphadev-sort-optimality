# n=5 model=out iset=I1 prefix14_class=9671
mov S2, P3
mov S1, P2
cmp P3, P0
cmovge S2, P0
cmovle P3, P0
cmp S1, P1
cmovl S1, P1
cmovl P1, P2
cmp P3, S1
cmovge P2, S1
cmovg S1, P3
cmovg P3, P2
cmp S2, P1
cmovle P2, P1
