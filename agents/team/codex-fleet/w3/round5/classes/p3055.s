# n=5 model=out iset=I1 prefix14_class=3055
mov S1, P0
cmp P3, P0
cmovge P0, P3
cmovge P3, S1
mov S1, P1
cmp P2, S1
cmovle P1, P2
cmovl P2, S1
mov S1, P3
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
mov P3, S1
cmp P0, P2
