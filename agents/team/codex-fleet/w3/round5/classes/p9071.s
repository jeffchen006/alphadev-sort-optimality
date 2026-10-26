# n=5 model=out iset=I1 prefix14_class=9071
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
mov S0, P3
cmovl S1, P0
cmp S0, P2
mov P0, S1
cmovle S0, P2
cmovle P2, P3
cmp S0, P1
cmovle P3, S0
cmovl S0, P1
cmovle P1, P3
cmp P2, S1
