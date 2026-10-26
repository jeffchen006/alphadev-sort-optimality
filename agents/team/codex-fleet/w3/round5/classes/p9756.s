# n=5 model=out iset=I1 prefix14_class=9756
mov S2, P0
cmp P1, P0
mov S0, P2
cmovle S2, P1
cmovle P1, P0
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
cmp P3, P1
cmovg S1, P1
cmovg P1, P3
cmovg P3, S1
cmp S2, S0
mov P1, S2
