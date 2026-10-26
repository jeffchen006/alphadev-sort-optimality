# n=5 model=out iset=I1 prefix14_class=6052
mov S0, P0
cmp P0, P2
cmovl S0, P2
cmovle P2, P0
cmp P3, P1
mov P0, P1
cmovle P0, P3
cmovl P3, P1
mov S2, S0
cmp P3, S0
cmovle S2, P3
cmovg S0, P3
cmp P2, P0
cmovle S0, P2
