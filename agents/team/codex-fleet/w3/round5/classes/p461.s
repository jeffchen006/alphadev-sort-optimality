# n=5 model=out iset=I1 prefix14_class=461
cmp P2, P0
mov S1, P2
cmovl S1, P0
mov S2, P3
cmovle P0, P2
cmp P3, P1
mov S0, S1
cmovg S2, P1
mov P2, P0
cmovg P1, P3
cmp S2, P0
cmovle P0, S2
cmovle S2, P2
mov P0, S2
