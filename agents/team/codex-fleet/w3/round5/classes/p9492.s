# n=5 model=out iset=I1 prefix14_class=9492
cmp P1, P0
mov S0, P0
cmovl P0, P1
cmovg S0, P1
cmp P3, P2
cmovg S1, P3
cmovg P3, P2
mov P1, P3
cmovg P2, S1
cmp P0, P1
cmovle P3, P0
cmovle P0, P1
cmp S0, P2
cmovle S1, S0
