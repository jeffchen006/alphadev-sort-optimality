# n=5 model=out iset=I1 prefix14_class=7742
mov S2, P1
mov S0, P2
cmp S0, P3
cmovle S0, P3
cmovle P3, P2
cmp P1, P0
cmovge P1, P0
cmovg P0, S2
mov S2, P1
cmp S2, P3
cmovl S2, P3
cmovg P1, P3
cmp P0, S0
cmovge P3, S0
