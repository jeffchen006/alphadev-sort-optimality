# n=5 model=out iset=I1 prefix14_class=2900
mov S1, P3
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovle P2, S2
mov S0, P2
cmp P3, P1
cmovl S1, P1
cmovge P3, P1
cmp S0, S1
cmovle S0, S1
mov S0, P3
cmovle S1, P2
cmp S0, P0
