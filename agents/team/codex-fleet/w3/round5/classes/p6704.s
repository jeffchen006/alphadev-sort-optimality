# n=5 model=out iset=I1 prefix14_class=6704
mov S1, P2
cmp P2, P1
cmovge S1, P1
cmovle P2, P1
mov P1, P0
cmp P3, P0
cmovl P0, P3
cmovle P3, P1
cmovge P1, P3
cmp P2, P3
cmovle P1, P2
cmovge P3, P2
cmp S1, P0
cmovg S0, P0
