# n=5 model=out iset=I1 prefix14_class=3658
mov S0, P0
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
cmp P3, P0
mov S2, P2
cmovle S0, P3
cmovle P3, P0
cmp S0, P2
cmovle S2, S0
cmovg P2, S0
cmp P3, P1
cmovg S2, P1
