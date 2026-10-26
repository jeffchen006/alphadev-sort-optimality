# n=5 model=out iset=I1 prefix14_class=3928
mov S1, P2
cmp P0, P2
mov S0, P1
cmovle S1, P0
cmovg P2, P0
cmovg P0, S1
cmp P3, P1
cmovle P1, P3
cmovge S0, P3
cmp S1, P1
cmovl S1, P1
cmovle P1, P0
cmp S0, P2
cmovle P3, P2
