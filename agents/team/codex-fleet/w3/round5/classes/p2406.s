# n=5 model=out iset=I1 prefix14_class=2406
mov S0, P0
cmp P3, S0
mov S1, P2
cmovge P0, P3
cmovge P3, S0
cmp P1, S1
cmovle P2, P1
cmovge S1, P1
cmp S1, P0
cmovg P1, S1
cmovle P1, P0
cmovge S1, P0
cmp P3, P2
cmovl P1, P2
