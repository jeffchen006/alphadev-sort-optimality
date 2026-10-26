# n=5 model=out iset=I1 prefix14_class=2448
mov S2, P2
cmp S2, P1
cmovge P2, P1
cmovl S2, P1
mov S0, P3
cmp P0, P3
cmovg P3, P0
cmovge P0, S0
cmovg S0, P3
cmp P3, S2
cmovle P3, S2
cmovle S2, S0
cmp P0, P2
cmovg S0, P0
