# n=5 model=out iset=I1 prefix14_class=1313
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovle P3, S1
cmp P2, P1
mov S1, P2
cmovge S1, P1
cmovge P1, P2
mov P2, P3
cmp P1, P3
cmovg P3, P1
cmovge P1, P2
mov P3, P0
cmovle P2, P1
