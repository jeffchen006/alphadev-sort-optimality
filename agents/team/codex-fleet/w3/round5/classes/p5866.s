# n=5 model=out iset=I1 prefix14_class=5866
mov S2, P2
cmp P2, P1
cmovg S2, P1
mov S1, P3
cmovle P2, P1
cmp P0, S1
mov P1, P2
cmovl P3, P0
cmovle P0, S1
cmp P0, P2
cmovge P1, P0
cmovle P2, P0
cmp S2, P3
cmovl P1, S2
