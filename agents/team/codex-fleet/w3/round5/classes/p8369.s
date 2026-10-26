# n=5 model=out iset=I1 prefix14_class=8369
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
mov S2, P0
cmovle P3, S1
cmp P2, P0
cmovl S2, P2
mov S0, S2
cmovl P2, P0
cmp S2, P3
cmovl S0, P3
cmovg S2, P3
mov P0, P1
mov P3, S0
