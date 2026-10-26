# n=5 model=out iset=I1 prefix14_class=883
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmovle P3, S0
cmp P1, P2
cmovg S2, P1
cmovg P1, P2
mov S0, P3
cmovg P2, S2
cmp P2, P3
cmovl S0, P2
mov S1, P1
cmovg P3, P2
cmp S1, P0
