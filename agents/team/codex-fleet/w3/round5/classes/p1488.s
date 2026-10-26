# n=5 model=out iset=I1 prefix14_class=1488
mov S0, P0
mov S1, P1
cmp P1, P3
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
cmovl P0, P2
cmovl P2, S0
cmp P0, S1
cmovg S0, S1
cmovg S1, P0
cmovg P0, S0
cmp P2, P1
mov P3, P1
