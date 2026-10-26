# n=5 model=out iset=I1 prefix14_class=4252
cmp P3, P0
mov S1, P0
cmovl P0, P3
cmovg S1, P3
mov S2, P1
cmp P2, P1
cmovg P1, P2
cmovg P2, S2
mov P3, P2
cmp P0, P3
cmovle P2, P0
cmovge P3, P0
cmp P1, S1
cmovge S0, P1
