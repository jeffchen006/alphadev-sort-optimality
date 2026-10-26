# n=5 model=out iset=I1 prefix14_class=2679
mov S1, P2
cmp P3, S1
cmovge S1, P3
cmovle P2, P3
cmp P1, P0
mov S2, P1
cmovle S2, P0
cmovge P1, P0
mov P0, S2
cmp S1, P0
cmovl S2, S1
cmovle S1, P0
mov S1, P1
cmp P1, P2
