# n=5 model=out iset=I1 prefix14_class=13614
mov S1, P1
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmovle P2, S0
cmp P0, S1
cmovle P1, P0
cmovg S1, P0
mov P0, P2
cmp P1, P0
cmovg P2, P1
cmovl P0, P1
cmp S1, P3
mov P0, P3
