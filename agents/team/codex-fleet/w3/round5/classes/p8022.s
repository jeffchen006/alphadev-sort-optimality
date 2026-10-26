# n=5 model=out iset=I1 prefix14_class=8022
mov S2, P3
cmp S2, P0
cmovl P3, P0
mov S1, P2
cmovge S2, P0
cmp P2, P1
cmovge P2, P1
mov P0, P2
cmovl S1, P1
cmp P2, S2
cmovle P0, S2
cmovle S2, P2
cmp S1, P3
cmovle P2, S1
