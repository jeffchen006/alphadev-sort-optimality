# n=5 model=out iset=I1 prefix14_class=8384
mov S0, P1
cmp P2, P3
mov S2, P2
cmovle S2, P3
cmovle P3, P2
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmp S2, P0
cmovle P1, S2
cmovl S2, P0
cmovle P0, P1
cmp S0, P3
mov S1, S0
