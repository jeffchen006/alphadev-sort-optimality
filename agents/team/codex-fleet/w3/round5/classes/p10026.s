# n=5 model=out iset=I1 prefix14_class=10026
mov S0, P1
mov S2, P2
cmp S0, P0
cmovge P1, P0
cmovle S0, P0
cmp S2, P3
cmovg P2, P3
cmovg P3, S2
cmp P3, S0
mov S2, P1
cmovle S1, S0
cmovl S0, P3
cmovle P3, S1
cmp P2, S2
