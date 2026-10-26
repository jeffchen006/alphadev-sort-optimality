# n=5 model=out iset=I1 prefix14_class=759
cmp P2, P0
mov S1, P3
cmovle S0, P2
cmovge S0, P0
cmovle P2, P0
cmp P3, P1
cmovge P3, P1
cmovl S1, P1
mov P0, S0
cmp S1, P2
cmovle P1, P2
cmovle P2, S1
cmovg P1, S1
cmp S0, P3
