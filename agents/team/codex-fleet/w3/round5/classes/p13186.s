# n=5 model=out iset=I1 prefix14_class=13186
mov S2, P0
cmp P2, S2
cmovl P0, P2
cmovg S2, P2
cmp P1, P3
mov P2, P0
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
cmp P0, P3
cmovg P0, P3
cmovle P2, P3
mov P0, S2
cmp P1, S2
