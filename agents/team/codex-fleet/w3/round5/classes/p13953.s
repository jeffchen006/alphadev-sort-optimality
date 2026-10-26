# n=5 model=out iset=I1 prefix14_class=13953
cmp P1, P3
cmovle S2, P1
cmovg S2, P3
cmovl P1, P3
cmp P0, P2
cmovg S1, P2
cmovle S1, P0
cmovg P2, P0
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
cmovl P2, S0
cmp S2, S1
mov P2, S2
