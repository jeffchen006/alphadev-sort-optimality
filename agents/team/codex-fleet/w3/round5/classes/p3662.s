# n=5 model=out iset=I1 prefix14_class=3662
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovg S1, P1
cmp P0, P2
cmovl P1, P2
cmovl P2, P0
cmovl P0, P1
cmp P2, P3
mov S0, P3
cmovg S0, P2
mov S2, S1
cmovle P3, P2
cmp P0, S1
