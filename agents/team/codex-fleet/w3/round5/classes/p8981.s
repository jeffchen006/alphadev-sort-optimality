# n=5 model=out iset=I1 prefix14_class=8981
cmp P3, P1
cmovl S0, P1
cmovge S0, P3
cmovg P3, P1
cmp P0, P2
mov S1, P0
cmovge P0, P2
cmovle S1, P2
cmp S0, S1
cmovle P2, S1
cmovle S1, S0
mov P1, P3
cmovle S0, P2
cmp P1, P0
