# n=5 model=out iset=I1 prefix14_class=2451
cmp P2, P0
mov S1, P3
mov S2, P2
cmovg S2, P0
cmovl P2, P0
cmp P1, P3
cmovge P3, P1
cmovge P1, S1
cmp P3, P2
mov S1, P3
cmovle P3, P2
cmovle P2, S1
cmp P1, S2
cmovl P3, S2
