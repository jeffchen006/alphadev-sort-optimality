# n=5 model=out iset=I1 prefix14_class=4886
mov S2, P1
mov S1, P3
cmp P0, S2
cmovl P1, P0
cmovle P0, S2
cmp P2, P3
cmovle P3, P2
cmovle P2, S1
mov S2, P3
cmp P3, P1
cmovge P3, P1
cmovl S2, P1
cmp P2, P0
cmovge P3, P2
