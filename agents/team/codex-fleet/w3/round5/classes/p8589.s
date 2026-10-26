# n=5 model=out iset=I1 prefix14_class=8589
mov S0, P1
cmp P3, P0
cmovle S2, P0
cmovle P0, P3
cmovl P3, S2
cmp S0, P2
cmovg S0, P2
cmovg P2, P1
mov P1, P3
cmp P1, P2
mov S1, P0
cmovl P3, P2
cmovl P2, P1
cmp P0, S0
