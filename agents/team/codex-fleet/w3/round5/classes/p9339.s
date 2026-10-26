# n=5 model=out iset=I1 prefix14_class=9339
cmp P2, P0
cmovg S2, P0
cmovle S2, P2
cmovg P0, P2
cmp P3, P1
cmovl P2, P1
cmovl P1, P3
cmovl P3, P2
cmp P1, S2
mov S0, P1
cmovl P1, S2
cmovg S0, S2
cmovg S2, P1
cmp P0, P3
