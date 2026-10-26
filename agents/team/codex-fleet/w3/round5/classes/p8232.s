# n=5 model=out iset=I1 prefix14_class=8232
cmp P0, P1
mov S2, P1
cmovl P1, P0
cmovle P0, S2
mov S1, P1
cmp P3, P2
cmovg S2, P2
cmovge P2, P3
mov S0, P2
cmovg P3, S2
cmp P1, P3
cmovge S1, P3
cmovle P1, P3
cmp P2, P0
