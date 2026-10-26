# n=5 model=out iset=I1 prefix14_class=13928
cmp P0, P3
mov S2, P0
cmovle S2, P3
mov S1, S2
cmovl P3, P0
cmp P2, P1
cmovge P0, P1
cmovge P1, P2
cmovge P2, P0
cmp S2, P1
cmovge S2, P1
cmovl S1, P1
mov P1, P2
cmp P3, P2
