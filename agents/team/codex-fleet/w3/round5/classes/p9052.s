# n=5 model=out iset=I1 prefix14_class=9052
mov S2, P1
mov S0, P0
cmp P2, S2
cmovl S2, P2
cmovl P2, P1
cmp P3, P0
cmovg S0, P3
cmovle P0, P3
cmp S0, P2
cmovle S1, S0
cmovle S0, P2
mov S0, P0
cmovl P2, S1
cmp P0, S2
