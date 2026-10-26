# n=5 model=out iset=I1 prefix14_class=14075
mov S0, P2
cmp P0, P1
cmovle S2, P0
cmovl P0, P1
cmovle P1, S2
cmp P3, P2
mov S1, P0
cmovle S0, P3
cmovl P3, P2
cmp P0, P3
cmovg S1, P3
cmovl P0, P3
cmp S0, P1
mov P3, P1
