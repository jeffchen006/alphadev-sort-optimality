# n=5 model=out iset=I1 prefix14_class=7408
cmp P1, P3
mov S0, P2
cmovle S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P2, P0
cmovg S0, P0
cmovg P0, P2
mov S1, S0
cmp P3, S1
cmovg S1, P3
cmovg P3, S0
cmp P1, P0
cmovl P3, P0
