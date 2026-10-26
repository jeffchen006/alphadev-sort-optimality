# n=5 model=out iset=I1 prefix14_class=1568
mov S1, P2
mov S2, P3
cmp P0, S1
cmovge S1, P0
cmovl P2, P0
cmp P1, P3
cmovle P3, P1
cmovge S2, P1
mov P0, S1
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
cmovg P3, S0
cmp S2, S1
