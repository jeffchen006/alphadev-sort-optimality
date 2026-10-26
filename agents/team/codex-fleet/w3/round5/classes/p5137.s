# n=5 model=out iset=I1 prefix14_class=5137
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
mov S2, P0
cmovg S1, P3
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovl P1, S0
mov P3, P1
cmp P0, P2
cmovg S2, P2
cmovg P2, P0
cmp S1, P3
