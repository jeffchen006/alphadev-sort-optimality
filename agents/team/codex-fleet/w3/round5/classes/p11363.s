# n=5 model=out iset=I1 prefix14_class=11363
mov S2, P2
cmp P0, P2
cmovle P2, P0
cmovle P0, S2
cmp P3, P1
mov S0, P3
cmovg S0, P1
cmovl P3, P1
cmp P3, P0
cmovg S1, P0
cmovge P0, P3
cmovg P3, S1
mov P0, P2
mov S2, P3
