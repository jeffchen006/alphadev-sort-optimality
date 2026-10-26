# n=5 model=out iset=I1 prefix14_class=13439
cmp P2, P1
mov S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P0, P3
mov S0, P0
cmovle S0, P3
cmovle P3, P0
cmp P3, P2
cmovle P0, P2
cmovle P2, P3
cmovle P3, P0
cmp P1, S0
cmovl P2, P1
