# n=5 model=out iset=I1 prefix14_class=3971
cmp P2, P3
mov S1, P2
mov S2, P1
cmovl P2, P3
cmovl P3, S1
cmp P0, P1
cmovle P1, P0
cmovge S2, P0
cmp P1, P3
cmovg S1, P3
cmovge P3, P1
cmovg P1, S1
mov P1, S2
cmp P2, S2
