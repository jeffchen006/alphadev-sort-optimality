# n=5 model=out iset=I1 prefix14_class=10520
cmp P3, P2
mov S0, P0
mov S2, P3
cmovg S2, P2
cmovle P3, P2
cmp P1, S0
cmovg P0, P1
cmovg P1, S0
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P1, S2
cmovg P2, P1
