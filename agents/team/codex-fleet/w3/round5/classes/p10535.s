# n=5 model=out iset=I1 prefix14_class=10535
mov S2, P1
cmp P1, P2
cmovl P1, P2
cmovl P2, S2
mov S1, P3
cmp P0, P3
mov S0, P2
cmovg P3, P0
cmovg P0, S1
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P0, P2
