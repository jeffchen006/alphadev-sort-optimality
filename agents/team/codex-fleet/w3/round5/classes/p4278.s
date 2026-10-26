# n=5 model=out iset=I1 prefix14_class=4278
cmp P3, P0
mov S0, P3
cmovge P3, P0
cmovl S0, P0
cmp P1, P2
mov S2, P2
cmovle S2, P1
cmovle P1, P2
cmp S2, P3
cmovle P0, P3
cmovle P3, S2
cmovg P0, S2
cmp P1, S0
cmovg P2, S0
