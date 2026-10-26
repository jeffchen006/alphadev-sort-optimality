# n=5 model=out iset=I1 prefix14_class=7823
cmp P0, P1
mov S2, P0
cmovge P0, P1
cmovge P1, S2
cmp P2, P3
cmovg S2, P2
mov S1, P0
cmovge P2, P3
cmovg P3, S2
cmp P0, P2
cmovl P0, P2
cmovge S1, P2
cmp P3, P1
mov S1, P3
