# n=5 model=out iset=I1 prefix14_class=13640
cmp P3, P0
mov S1, P0
cmovge P0, P3
cmovl S1, P3
cmp P2, P1
mov S2, P2
cmovge S2, P1
cmovle P2, P1
cmp S1, S2
cmovge P1, S2
cmovg S2, S1
cmovge S1, P1
cmp P2, P0
mov P3, P2
