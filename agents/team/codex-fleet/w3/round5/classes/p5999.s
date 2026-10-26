# n=5 model=out iset=I1 prefix14_class=5999
mov S2, P3
cmp P3, P0
cmovg S2, P0
mov S1, P1
cmovle P3, P0
cmp P2, S1
mov S0, S2
cmovl P1, P2
cmovg S1, P2
cmp P3, S1
cmovge P0, S1
cmovg S1, P3
cmovg P3, P0
cmp P1, S2
