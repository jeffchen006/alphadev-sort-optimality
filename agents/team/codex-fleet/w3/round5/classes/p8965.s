# n=5 model=out iset=I1 prefix14_class=8965
cmp P1, P0
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
mov S1, P3
cmp S1, P2
cmovl P3, P2
cmovle P2, S1
mov S1, P3
cmp P1, P3
cmovl P3, P1
cmovg S1, P1
cmp P0, P2
mov P1, P2
