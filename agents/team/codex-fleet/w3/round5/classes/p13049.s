# n=5 model=out iset=I1 prefix14_class=13049
mov S1, P0
cmp P2, P0
cmovl S1, P2
cmovg P0, P2
cmp P1, P3
cmovl S2, P1
cmovl P1, P3
cmovl P3, S2
mov S0, P3
cmp P3, S1
cmovle P3, S1
cmovle S1, S0
mov P2, P0
mov S1, P3
