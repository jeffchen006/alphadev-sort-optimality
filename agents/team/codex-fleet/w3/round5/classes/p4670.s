# n=5 model=out iset=I1 prefix14_class=4670
mov S1, P2
mov S2, P0
cmp P1, P0
cmovge P0, P1
cmovg P1, S2
cmp P3, S1
cmovle P2, P3
mov S0, P2
cmovl P3, S1
cmp P3, P0
cmovg S1, P0
cmovg P0, P3
cmovg P3, S1
cmp P2, P1
