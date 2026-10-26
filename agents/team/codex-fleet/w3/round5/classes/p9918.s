# n=5 model=out iset=I1 prefix14_class=9918
cmp P1, P3
mov S2, P1
cmovg P1, P3
cmovg P3, S2
mov S1, P2
cmp P2, P0
mov S0, P3
cmovg P2, P0
cmovle S1, P0
cmp S1, P3
cmovg S0, S1
cmovle P3, S1
cmp P2, P1
cmovl S2, P1
