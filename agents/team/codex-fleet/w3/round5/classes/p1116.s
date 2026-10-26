# n=5 model=out iset=I1 prefix14_class=1116
cmp P2, P1
mov S0, P2
mov S2, P3
cmovle P2, P1
cmovle P1, S0
cmp P0, S2
cmovg S2, P0
cmovg P0, P3
mov S0, P2
cmp S0, S2
cmovl S0, S2
cmovle S2, P2
mov P2, P0
cmp P1, P2
