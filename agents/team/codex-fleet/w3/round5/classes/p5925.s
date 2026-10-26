# n=5 model=out iset=I1 prefix14_class=5925
mov S2, P0
mov S1, P2
cmp S2, P3
cmovl S2, P3
cmovge P0, P3
cmp P1, S1
cmovg P2, P1
mov P3, P2
cmovg P1, S1
cmp P2, S2
cmovl P2, S2
cmovle S2, P3
cmp P1, P0
cmovle S1, P1
