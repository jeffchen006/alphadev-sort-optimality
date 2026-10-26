# n=5 model=out iset=I1 prefix14_class=12903
mov S1, P3
cmp P1, S1
cmovg P3, P1
cmovge P1, S1
cmp P0, P2
mov S2, P0
cmovge S2, P2
cmovle P0, P2
cmp S2, P1
cmovle P2, P1
mov S1, P0
cmovl P1, S2
cmovl S2, P2
cmp S1, P3
