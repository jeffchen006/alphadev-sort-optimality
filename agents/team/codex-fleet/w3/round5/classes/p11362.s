# n=5 model=out iset=I1 prefix14_class=11362
mov S0, P3
cmp P0, P3
cmovl P3, P0
cmovle P0, S0
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovg S2, P1
cmp P2, P0
cmovg S1, P0
cmovg P0, P2
cmovg P2, S1
mov P0, P3
mov S0, P2
