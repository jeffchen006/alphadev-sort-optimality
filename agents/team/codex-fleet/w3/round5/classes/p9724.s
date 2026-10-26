# n=5 model=out iset=I1 prefix14_class=9724
mov S1, P0
cmp P1, P2
cmovl S2, P2
cmovge S2, P1
cmovge P1, P2
cmp S1, P3
cmovl S1, P3
cmovle P3, P0
cmp S2, S1
cmovle P0, S2
cmovle S2, S1
mov S0, P3
cmovl S1, P0
cmp P3, P1
