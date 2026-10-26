# n=5 model=out iset=I1 prefix14_class=2353
mov S0, P0
cmp P0, P1
cmovle P0, P1
cmovl P1, S0
mov S1, P2
cmp S1, P3
cmovle P2, P3
cmovg S1, P3
cmp P0, P2
mov P3, P2
cmovl P2, P0
cmovge P3, P0
cmp P1, S1
cmovg S0, P1
