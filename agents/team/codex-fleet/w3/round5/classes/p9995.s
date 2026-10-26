# n=5 model=out iset=I1 prefix14_class=9995
mov S1, P0
cmp S1, P1
cmovl P0, P1
cmovg S1, P1
mov S2, P3
cmp P2, P3
cmovl P3, P2
cmovle P2, S2
cmp P0, P2
cmovg P1, P2
cmovg P2, P0
cmovg P0, P1
cmp S1, P3
cmovle S2, S1
