# n=5 model=out iset=I1 prefix14_class=8212
mov S0, P1
cmp S0, P2
mov S2, P0
cmovge P1, P2
cmovle S0, P2
mov S1, P1
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmp P1, P3
cmovl S1, P3
cmovg P1, P3
cmp S2, S0
cmovle P3, S1
