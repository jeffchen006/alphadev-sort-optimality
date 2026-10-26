# n=5 model=out iset=I1 prefix14_class=9993
mov S1, P1
cmp P1, P3
cmovle P1, P3
mov S2, P0
cmovg S1, P3
cmp P2, S2
cmovl P0, P2
cmovl P2, S2
cmp P1, P2
cmovge P3, P2
cmovg P2, P1
cmovg P1, P3
cmp P0, S1
cmovl S0, P0
