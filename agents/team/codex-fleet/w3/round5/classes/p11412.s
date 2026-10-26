# n=5 model=out iset=I1 prefix14_class=11412
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
cmovle P1, S0
mov S1, P0
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
cmp P0, P2
cmovg S2, P0
mov P3, P1
cmovle S2, P2
cmovl P2, P0
cmovle P0, S2
