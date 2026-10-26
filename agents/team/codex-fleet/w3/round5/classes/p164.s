# n=5 model=out iset=I1 prefix14_class=164
mov S1, P2
cmp S1, P1
cmovl P2, P1
cmovg S1, P1
mov P1, P0
cmp P3, P0
cmovl P0, P3
cmovle P3, P1
cmp S1, P0
cmovle S0, P0
cmovg S0, S1
cmovg S1, P0
mov S2, S0
cmp P3, P2
