# n=5 model=out iset=I1 prefix14_class=8913
cmp P0, P1
mov S1, P3
cmovle S0, P0
cmovl P0, P1
cmovg S0, P1
cmp P2, P3
cmovl P3, P2
cmovle P2, S1
cmp P2, P0
mov P1, P3
cmovle S2, P2
cmovl P2, P0
cmovl P0, S2
cmp S0, P1
