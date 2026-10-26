# n=5 model=out iset=I1 prefix14_class=9379
cmp P1, P0
mov S2, P0
cmovle P0, P1
cmovg S2, P1
cmp P3, P2
mov S0, P0
cmovge P1, P2
cmovle P1, P3
cmovl P3, P2
cmp P0, P1
cmovle P0, P1
cmovle P1, S0
cmp P3, S2
cmovle P1, S2
