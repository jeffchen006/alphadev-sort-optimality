# n=5 model=out iset=I1 prefix14_class=12555
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
mov S2, P2
cmovle P0, S1
cmp P2, P1
cmovg S2, P1
cmovl P2, P1
cmp P0, S2
mov S0, P2
cmovle S1, S2
cmovle S2, P0
cmovl P0, S1
cmp S0, P3
