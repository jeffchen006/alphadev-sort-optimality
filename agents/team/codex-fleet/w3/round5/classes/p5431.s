# n=5 model=out iset=I1 prefix14_class=5431
cmp P0, P2
cmovg S0, P2
cmovge P2, P0
cmovg P0, S0
mov S0, P3
cmp P3, P1
cmovle S0, P1
cmovge P3, P1
cmp P3, P0
mov S2, P0
cmovg P0, P3
cmovl S2, P3
cmp S0, P2
cmovle P1, S0
