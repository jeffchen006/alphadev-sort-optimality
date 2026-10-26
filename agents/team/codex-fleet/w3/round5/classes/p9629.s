# n=5 model=out iset=I1 prefix14_class=9629
cmp P1, P2
cmovge S2, P2
cmovge P2, P1
mov S1, P0
cmovge P1, S2
cmp P3, P0
cmovge S1, P3
cmovg P3, P0
mov P0, S1
cmp P0, P2
cmovge S1, P2
cmovl P0, P2
cmp P1, P3
cmovge S2, P1
