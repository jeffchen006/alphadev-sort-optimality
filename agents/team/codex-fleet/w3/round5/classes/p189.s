# n=5 model=out iset=I1 prefix14_class=189
cmp P3, P0
mov S2, P0
cmovg P0, P3
cmovg P3, S2
mov S0, P2
cmp P1, S0
cmovle S0, P1
mov S1, P3
cmovle P1, P2
cmp S0, P3
cmovl S1, S0
cmovg P3, S0
mov P2, P0
mov S1, P3
