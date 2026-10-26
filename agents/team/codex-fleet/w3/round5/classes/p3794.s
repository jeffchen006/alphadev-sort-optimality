# n=5 model=out iset=I1 prefix14_class=3794
cmp P0, P3
mov S0, P0
cmovg P0, P3
cmovge P3, S0
mov S0, P2
cmp P1, P2
cmovl S0, P1
cmovle P1, P2
mov S1, P0
cmp S1, S0
cmovle S1, S0
cmovl S0, P0
cmp P3, P1
cmovle P0, P1
