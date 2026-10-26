# n=5 model=out iset=I1 prefix14_class=9561
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
mov S0, P2
cmovle P1, S1
cmp S0, P3
cmovg S0, P3
cmovg P3, P2
cmp P0, S0
cmovg P2, S0
cmovle P2, P0
cmovg S0, P0
cmp P1, P3
cmovg P0, P1
