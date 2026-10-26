# n=5 model=out iset=I1 prefix14_class=1150
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovle P0, S0
mov S2, P3
cmp S2, P1
cmovl P3, P1
cmovg S2, P1
mov S1, P3
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
mov P1, S2
cmp P0, P1
