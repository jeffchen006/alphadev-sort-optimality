# n=5 model=out iset=I1 prefix14_class=761
cmp P2, P1
cmovge S1, P1
cmovle S1, P2
cmovle P2, P1
mov S0, P0
cmp P0, P3
cmovl S0, P3
cmovg P0, P3
cmp S0, P2
cmovle P3, P2
cmovge P3, S0
cmovle P2, S0
mov P3, P0
cmp P3, S1
