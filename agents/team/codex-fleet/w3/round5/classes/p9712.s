# n=5 model=out iset=I1 prefix14_class=9712
cmp P1, P3
mov S1, P3
cmovg P3, P1
cmovg P1, S1
mov S2, P2
cmp P0, S2
cmovl S2, P0
cmovg P2, P0
cmp P2, P3
mov P0, S2
cmovle S0, P3
cmovl P3, P2
cmovle P2, S0
cmp P0, P1
