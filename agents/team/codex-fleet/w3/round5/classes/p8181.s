# n=5 model=out iset=I1 prefix14_class=8181
mov S0, P1
cmp P1, P3
cmovl P1, P3
cmovle P3, S0
cmp P0, P2
mov S1, P1
mov S2, P0
cmovge S2, P2
cmovl P0, P2
cmp P3, S2
cmovg P2, P3
cmovge P3, S2
cmovg S2, P2
cmp P1, P0
