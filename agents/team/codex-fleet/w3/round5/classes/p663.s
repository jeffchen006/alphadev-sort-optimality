# n=5 model=out iset=I1 prefix14_class=663
mov S1, P2
cmp P3, P2
cmovle P2, P3
mov S0, P1
cmovle P3, S1
cmp S0, P0
cmovle S0, P0
cmovge P1, P0
mov S1, P3
cmp S1, S0
cmovle S1, S0
cmovl S0, P3
cmp P2, P1
cmovl S1, P2
