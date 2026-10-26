# n=5 model=out iset=I1 prefix14_class=8231
cmp P0, P1
mov S2, P1
cmovl P1, P0
cmovle P0, S2
mov S1, P1
cmp P2, P3
cmovg S2, P3
cmovge P3, P2
mov S0, P3
cmovg P2, S2
cmp P1, P2
cmovge S1, P2
cmovle P1, P2
cmp P3, P0
