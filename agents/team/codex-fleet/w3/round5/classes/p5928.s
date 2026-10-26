# n=5 model=out iset=I1 prefix14_class=5928
mov S1, P3
cmp S1, P0
cmovl P3, P0
mov S0, P2
cmovg S1, P0
cmp P1, S0
cmovle S0, P1
mov P0, S0
cmovg P2, P1
cmp P2, P3
cmovl P1, P3
cmovle P3, P2
cmovl P2, P1
cmp P0, S1
