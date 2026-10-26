# n=5 model=out iset=I1 prefix14_class=9645
mov S1, P1
cmp S1, P3
cmovge P1, P3
cmovge P3, S1
cmp P0, P2
mov S1, P0
cmovle P0, P2
cmovg S1, P2
cmp P0, P3
cmovl P2, P3
cmovl P3, P0
cmovge P2, P0
cmp P1, S1
cmovge P2, S1
