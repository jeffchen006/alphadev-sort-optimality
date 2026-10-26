# n=5 model=out iset=I1 prefix14_class=9373
mov S0, P0
cmp P0, P2
cmovle P0, P2
cmovl P2, S0
mov S2, P2
mov S1, P1
cmp P3, P1
cmovle P1, P3
cmovle P3, S1
cmp P1, S2
cmovge S2, P1
cmovge P1, P2
cmp P3, P0
cmovge P2, P0
