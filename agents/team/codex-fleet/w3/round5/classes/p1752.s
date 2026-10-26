# n=5 model=out iset=I1 prefix14_class=1752
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmovg P2, S1
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P3
mov S1, P1
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
mov S1, P1
