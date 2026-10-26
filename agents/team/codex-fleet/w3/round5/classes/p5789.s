# n=5 model=out iset=I1 prefix14_class=5789
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovg S0, P1
cmovg P1, P3
cmp P2, P0
cmovg S1, P2
cmovg P2, P0
cmovg P0, S1
cmp P1, P2
cmovle P1, P2
cmovl P2, P3
cmp P0, S0
mov P3, P1
