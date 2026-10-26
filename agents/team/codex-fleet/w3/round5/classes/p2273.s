# n=5 model=out iset=I1 prefix14_class=2273
cmp P0, P1
cmovle S1, P0
mov S0, P2
cmovl P0, P1
cmovg S1, P1
cmp S0, P3
cmovg S0, P3
cmovl P2, P3
mov P3, P2
cmp P2, P0
cmovl P3, P0
cmovle P0, P2
cmp S1, S0
cmovle P2, S0
