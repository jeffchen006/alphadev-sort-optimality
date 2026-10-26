# n=5 model=out iset=I1 prefix14_class=260
cmp P0, P3
mov S2, P0
cmovg P0, P3
mov S1, P1
cmovg P3, S2
cmovg S2, P0
cmp P2, P1
cmovg P1, P2
cmovl S1, P2
cmovle P2, P1
cmp S1, S2
cmovle S2, S1
cmovle S1, P0
mov S0, S1
