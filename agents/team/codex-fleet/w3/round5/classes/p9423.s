# n=5 model=out iset=I1 prefix14_class=9423
mov S2, P0
cmp P2, P0
mov S1, P3
cmovg S2, P2
cmovg P2, P0
cmp P1, S1
cmovl P3, P1
cmovg S1, P1
cmp P2, P3
mov S0, P3
cmovl S0, P2
cmovge P3, P2
cmp S2, S1
cmovle P2, S2
