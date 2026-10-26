# n=5 model=out iset=I1 prefix14_class=12249
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P1, P3
mov P0, P3
cmovle P0, P1
cmovg P3, P1
cmp P0, S2
cmovle S0, P0
cmovl P0, S2
cmovl S2, S0
mov S2, P0
cmp P2, P3
