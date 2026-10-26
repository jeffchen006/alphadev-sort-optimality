# n=5 model=out iset=I1 prefix14_class=10971
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovle P1, S0
mov S1, P3
cmp P2, P0
cmovg S2, P2
cmovge P2, P0
cmovg P0, S2
cmp P0, P3
cmovl P3, P0
cmovg S1, P0
cmp P1, P2
cmovle P0, P2
