# n=5 model=out iset=I1 prefix14_class=1904
cmp P2, P0
mov S2, P0
cmovl P0, P2
cmovle P2, S2
mov S1, P3
cmp P1, S1
cmovle P3, P1
cmovle P1, S1
cmovg S1, P1
cmp P1, P2
cmovge S1, P2
cmovge P2, P1
cmp P0, P3
cmovge S2, P0
