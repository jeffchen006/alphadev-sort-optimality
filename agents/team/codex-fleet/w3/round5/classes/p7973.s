# n=5 model=out iset=I1 prefix14_class=7973
mov S0, P0
cmp P1, P2
cmovg S2, P1
cmovg P1, P2
cmovg P2, S2
cmp S0, P3
cmovle S0, P3
cmovge P0, P3
mov S1, P0
cmp P1, P0
cmovg P0, P1
cmovl S1, P1
cmovle P1, P0
mov S1, S0
