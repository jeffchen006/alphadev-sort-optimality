# n=5 model=out iset=I1 prefix14_class=14431
mov S2, P2
cmp P2, P3
mov S1, P0
cmovl P2, P3
cmovge S2, P3
cmp P1, S1
cmovg S1, P1
cmovl P0, P1
cmp S2, P0
cmovg P1, S2
cmovge S2, P0
cmovg P0, P1
cmp P2, S1
mov S2, P2
