# n=5 model=out iset=I1 prefix14_class=697
cmp P3, P1
cmovle S0, P3
cmovg S0, P1
cmovle P3, P1
mov P1, P0
mov S1, P3
cmp P1, P2
cmovg P1, P2
cmovl P0, P2
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
mov P3, P1
mov S2, P0
