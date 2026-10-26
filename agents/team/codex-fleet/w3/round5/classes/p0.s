# n=5 model=out iset=I1 prefix14_class=0
mov S2, P0
mov S1, P1
cmp P3, P1
cmovle P1, P3
cmovle P3, S1
cmp P2, P0
cmovge S2, P2
cmovl P0, P2
mov S1, P1
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
mov S0, P3
cmovle P1, P0
