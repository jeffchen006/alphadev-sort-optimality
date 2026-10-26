# n=5 model=out iset=I1 prefix14_class=8208
mov S2, P1
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
cmovle P0, S0
cmp S2, P0
cmovl P1, P0
cmovge P1, S2
cmovge S2, P0
mov S2, P2
mov P0, P1
