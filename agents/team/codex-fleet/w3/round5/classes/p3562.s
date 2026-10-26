# n=5 model=out iset=I1 prefix14_class=3562
cmp P3, P2
mov S1, P3
cmovle P3, P2
mov S0, P1
cmovle P2, S1
mov S2, P3
cmp P0, P1
cmovl P1, P0
cmovge S0, P0
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmovg P2, S1
cmp S0, S2
