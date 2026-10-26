# n=5 model=out iset=I1 prefix14_class=1875
mov S2, P0
mov S1, P1
cmp P2, P0
cmovl P0, P2
cmovl P2, S2
mov S0, P2
cmp P3, S1
cmovg P1, P3
cmovle S1, P3
cmp P1, S0
cmovl P2, P1
cmovle P1, S0
cmp P0, S1
cmovle S2, P0
