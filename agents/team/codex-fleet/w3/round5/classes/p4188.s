# n=5 model=out iset=I1 prefix14_class=4188
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmovg S2, P0
cmovg P0, P3
cmp P1, P2
mov S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P2, P0
cmovg P3, P2
cmovle P0, P2
mov P0, P1
cmp P0, S2
