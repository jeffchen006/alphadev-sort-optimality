# n=5 model=out iset=I1 prefix14_class=4878
cmp P3, P1
cmovle S2, P1
mov S1, P2
cmovle P1, P3
cmovle P3, S2
cmp P0, P2
cmovl S1, P0
cmovle P0, P2
cmp S1, P1
cmovle S0, S1
cmovge S0, P1
cmovl S1, P1
cmp P0, P3
cmovge P2, P0
