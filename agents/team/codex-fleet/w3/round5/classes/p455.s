# n=5 model=out iset=I1 prefix14_class=455
cmp P1, P3
mov S1, P3
cmovg S1, P1
cmovl P3, P1
cmp P0, P2
mov S2, P0
cmovg P0, P2
cmovg P2, S2
mov S2, P3
mov S0, S1
cmp P0, P3
cmovl P3, P0
cmovle P0, S2
mov P3, P0
