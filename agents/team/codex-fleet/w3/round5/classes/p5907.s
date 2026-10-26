# n=5 model=out iset=I1 prefix14_class=5907
cmp P3, P2
mov S0, P0
mov S2, P3
cmovl S2, P2
cmovg P3, P2
cmp P1, P0
cmovg S0, P1
cmovg P1, P0
mov P2, P1
cmp S0, S2
cmovle P0, S0
cmovle S0, S2
cmovl S2, P0
mov S1, S2
