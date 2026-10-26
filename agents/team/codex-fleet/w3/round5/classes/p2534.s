# n=5 model=out iset=I1 prefix14_class=2534
cmp P1, P0
mov S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
mov S1, P1
cmp S1, P3
cmovg S1, P3
cmovl P1, P3
mov P1, P2
cmp P2, P0
