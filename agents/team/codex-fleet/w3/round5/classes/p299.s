# n=5 model=out iset=I1 prefix14_class=299
cmp P1, P3
mov S2, P0
cmovge S0, P1
cmovge P1, P3
cmovge P3, S0
cmp P2, P0
cmovg S2, P2
cmovle P0, P2
cmp P1, P0
cmovle P2, P0
cmovl P0, P1
cmovle P1, P2
cmp S2, P3
mov P0, P3
