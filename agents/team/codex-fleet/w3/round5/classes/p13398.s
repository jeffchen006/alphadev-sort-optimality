# n=5 model=out iset=I1 prefix14_class=13398
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmovge P2, S2
cmp P3, P1
mov S1, P1
cmovg S1, P3
cmovl P1, P3
cmovge P3, P1
cmp P0, P1
cmovl P3, P0
cmovl P0, P1
cmp P2, S1
cmovle P1, S1
