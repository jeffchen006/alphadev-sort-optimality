# n=5 model=out iset=I1 prefix14_class=6812
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P2, P3
mov S1, P3
cmovl P3, P2
mov S2, P3
cmovg S1, P2
cmp S1, P1
cmovle P2, P1
cmovl P1, S1
cmovg P2, S1
cmovg S1, P1
