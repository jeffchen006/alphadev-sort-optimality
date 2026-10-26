# n=5 model=out iset=I1 prefix14_class=12519
mov S0, P1
cmp P3, P1
mov S1, P2
cmovl P1, P3
cmovle P3, S0
cmp P2, P0
cmovge P2, P0
cmovg P0, S1
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp P0, P3
mov P2, P0
