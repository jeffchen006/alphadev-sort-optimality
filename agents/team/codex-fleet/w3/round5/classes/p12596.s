# n=5 model=out iset=I1 prefix14_class=12596
cmp P0, P1
cmovg S0, P1
cmovle S0, P0
cmovl P0, P1
cmp P3, P2
cmovle S2, P2
mov P1, S0
cmovl P2, P3
cmovle P3, S2
cmp P2, P1
cmovle P1, P2
cmovl P2, S0
cmp P3, P0
mov S0, P0
