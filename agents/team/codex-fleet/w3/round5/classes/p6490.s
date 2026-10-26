# n=5 model=out iset=I1 prefix14_class=6490
mov S1, P0
cmp P1, P0
mov S2, P2
cmovle P0, P1
cmovg S1, P1
cmp P3, P2
cmovge P2, P3
cmovle S2, P3
cmp S1, P2
mov P3, P2
cmovl P3, S1
cmovl S1, P2
cmp S2, P0
cmovge S1, S2
