# n=5 model=out iset=I1 prefix14_class=2813
cmp P1, P2
mov S1, P1
mov S2, P3
cmovg S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P0, S2
cmovl P3, P0
cmovle P0, S2
cmp P0, P2
cmovge S2, P2
cmovg P2, P0
cmovge P0, S2
cmp P1, P3
