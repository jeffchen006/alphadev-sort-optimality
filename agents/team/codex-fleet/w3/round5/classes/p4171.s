# n=5 model=out iset=I1 prefix14_class=4171
mov S1, P1
cmp P0, P1
mov S2, P2
cmovg P1, P0
cmovl S1, P0
cmp P2, P3
cmovle P2, P3
mov P0, S1
cmovl P3, S2
cmp P3, P0
cmovl S1, P3
cmovge P0, P3
mov P3, P1
mov S1, P0
