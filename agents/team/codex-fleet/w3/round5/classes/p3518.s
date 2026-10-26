# n=5 model=out iset=I1 prefix14_class=3518
mov S2, P0
cmp P0, P2
cmovge S2, P2
cmovg P2, P0
mov P0, S2
cmp P1, P3
cmovl S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P3, S2
cmovg S2, P3
mov S1, P2
cmovge P3, P0
cmp P1, S1
