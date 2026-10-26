# n=5 model=out iset=I1 prefix14_class=7960
cmp P3, P2
mov S1, P3
cmovge P3, P2
cmovl S1, P2
cmp P1, P0
cmovl S2, P1
cmovge S2, P0
cmovge P0, P1
cmp P3, S2
cmovg P1, P3
cmovle P1, S2
cmovge P3, S2
mov P3, P1
cmp P0, S1
