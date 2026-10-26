# n=5 model=out iset=I1 prefix14_class=12137
cmp P3, P0
mov S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P1, P2
cmovg S2, P1
mov S1, P3
cmovge P1, P2
cmovg P2, S2
cmp P1, S1
cmovg S1, P1
cmovl P3, P1
mov P3, P2
cmovle P1, S1
