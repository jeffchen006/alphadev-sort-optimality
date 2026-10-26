# n=5 model=out iset=I1 prefix14_class=12536
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P0, P1
cmovg S0, P0
cmovg P0, P1
mov S1, P2
cmovg P1, S0
cmp P0, P2
cmovg S1, P0
cmovg P0, P2
cmp P1, P3
cmovle S2, P1
