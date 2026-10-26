# n=5 model=out iset=I1 prefix14_class=13820
mov S2, P3
mov S1, P2
cmp P2, P1
cmovl S1, P1
cmovg P2, P1
cmp P0, P3
cmovg S2, P0
cmovle P3, P0
mov S0, S2
cmp S2, S1
cmovle S2, S1
cmovg S0, S1
cmp P2, P3
cmovg P1, P2
